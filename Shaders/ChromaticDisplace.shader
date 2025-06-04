Shader "Hidden/M8/PostProcessEffects/ChromaticDisplace"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
		uniform float4 _MainTex_TexelSize;

		float displace;

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float2 pos = (i.texcoord - 0.5) * 2.0;
			float magSq = dot(pos, pos);
			float2 ofs = displace * magSq * pos;
			float2 uvR = i.texcoord - _MainTex_TexelSize.xy * ofs;
			float2 uvB = i.texcoord + _MainTex_TexelSize.xy * ofs;

			float4 clr = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			return float4(
				SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uvR).r,
				clr.g,
				SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uvB).b,
				clr.a);
		}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Frag
			ENDHLSL
		}
	}
}