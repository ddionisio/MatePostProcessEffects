inline float4 ComputeNonStereoScreenPos(float4 pos) {
	float4 o = pos * 0.5f;
	o.xy = float2(o.x, o.y * _ProjectionParams.x) + o.w;
	o.zw = pos.zw;
	return o;
}

inline float4 ComputeScreenPos(float4 pos) {
	float4 o = ComputeNonStereoScreenPos(pos);
#if defined(UNITY_SINGLE_PASS_STEREO)
	o.xy = TransformStereoScreenSpaceTex(o.xy, pos.w);
#endif
	return o;
}