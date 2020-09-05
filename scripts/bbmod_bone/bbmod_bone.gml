/// @enum An enumeration of members of a legacy bone struct.
/// @see BBMOD_EModel.Skeleton
enum BBMOD_EBone
{
	/// @member {string} The name of the bone.
	/// @readonly
	Name,
	/// @member {real} The index of the bone.
	/// @readonly
	Index,
	/// @member {real[]} The transformation matrix.
	/// @readonly
	TransformMatrix,
	/// @member {real[]} The offset matrix.
	/// @readonly
	OffsetMatrix,
	/// @member {BBMOD_EBone[]} An array of child bones.
	/// @see BBMOD_EBone
	/// @readonly
	Children,
	/// @member The size of the struct.
	SIZE
};

/// @func bbmod_bone_load(_buffer)
/// @desc Loads a bone from a buffer.
/// @param {buffer} _buffer The buffer to load the struct from.
/// @return {BBMOD_EBone} The loaded bone.
/// @private
function bbmod_bone_load(_buffer)
{
	var _bone = array_create(BBMOD_EBone.SIZE, 0);

	_bone[@ BBMOD_EBone.Name] = buffer_read(_buffer, buffer_string);
	_bone[@ BBMOD_EBone.Index] = buffer_read(_buffer, buffer_f32);
	_bone[@ BBMOD_EBone.TransformMatrix] = bbmod_load_matrix(_buffer);
	_bone[@ BBMOD_EBone.OffsetMatrix] = bbmod_load_matrix(_buffer);

	var _child_count = buffer_read(_buffer, buffer_u32);
	var _children = array_create(_child_count, 0);

	_bone[@ BBMOD_EBone.Children] = _children;

	var i = 0
	repeat (_child_count)
	{
		_children[@ i++] = bbmod_bone_load(_buffer);
	}

	return _bone;
}