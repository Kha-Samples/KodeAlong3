package;

import kha.Framebuffer;
import kha.Color;
import kha.graphics4.CompareMode;
import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Assets;
import kha.Shaders;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.Scheduler;
import kha.System;

class Main {
	static var pipeline: PipelineState;
	static var vertexBuffer: VertexBuffer;
	static var indexBuffer: IndexBuffer;
	
	public static function main() {
		System.init({title: "MeshLoader", width: 800, height: 600}, function () {
			Assets.loadEverything(function () {
				start();
				System.notifyOnRender(render);
			});
		});
	}
		
	static function start(): Void {
		var data = new OgexData(Assets.blobs.tiger_ogex.toString());
		var vertices = data.geometryObjects[0].mesh.vertexArrays[0].values;
		var texcoords = data.geometryObjects[0].mesh.vertexArrays[2].values;
		var indices = data.geometryObjects[0].mesh.indexArray.values;
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("texcoord", VertexData.Float2);
		vertexBuffer = new VertexBuffer(vertices.length, structure, Usage.StaticUsage);
		var buffer = vertexBuffer.lock();
		for (i in 0...Std.int(vertices.length / 3)) {
			buffer.set(i * 5 + 0, vertices[i * 3 + 0]);
			buffer.set(i * 5 + 1, vertices[i * 3 + 1]);
			buffer.set(i * 5 + 2, vertices[i * 3 + 2]);
			buffer.set(i * 5 + 3, texcoords[i * 2 + 0]);
			buffer.set(i * 5 + 4, texcoords[i * 2 + 1]);
		}
		vertexBuffer.unlock();
		
		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var ibuffer = indexBuffer.lock();
		for (i in 0...indices.length) {
			ibuffer[i] = indices[i];
		}
		indexBuffer.unlock();
		
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.mesh_vert;
		pipeline.fragmentShader = Shaders.mesh_frag;
		pipeline.compile();
	}
	
	static function render(frame: Framebuffer): Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.Black, Math.POSITIVE_INFINITY);

		g.setPipeline(pipeline);
		
		g.setIndexBuffer(indexBuffer);
		g.setVertexBuffer(vertexBuffer);
		g.drawIndexedVertices();

		g.end();
	}
}
