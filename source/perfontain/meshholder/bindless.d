module perfontain.meshholder.bindless;

import
		std.range,
		std.algorithm,

		perfontain;


final class BindlessHolderCreator : HolderCreator
{
	this(in MeshInfo[] meshes, ubyte type, ubyte flags = 0)
	{
		super(meshes, type, flags);
	}

protected:
	override void makeData(ref HolderData res)
	{
		foreach(ref m; _meshes) with(res)
		{
			HolderMesh hm;

			foreach(ref s; m.subs)
			{
				auto idx = _texIndex[s.tex];
				auto start = cast(uint)data.indices.length;

				processSubMesh(data, s);
				hm.subs ~= HolderSubMesh(cast(uint)data.indices.length - start, start, idx);
			}

			meshes ~= hm;
		}

		foreach(im; _texIndex.byKeyValue.array.sort!((a, b) => a.value < b.value).map!(a => a.key))
		{
			add(res, im, true);
		}
	}

	void processSubMesh(ref SubMeshData data, ref in SubMeshInfo s)
	{
		auto len = data.indices.length;

		data.indices ~= s.data.indices;
		data.indices[len..$][] += cast(uint)data.vertices.length / _vsize;

		data.vertices ~= s.data.vertices;
	}
}
