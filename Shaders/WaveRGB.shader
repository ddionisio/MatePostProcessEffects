Shader "Hidden/M8/PostProcessEffects/WaveRGB"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float4 parmsR; // x,y = amplitude; z,w = range
		float2 ofsR;

		float4 parmsG; // x,y = amplitude; z,w = range
		float2 ofsG;

		float4 parmsB; // x,y = amplitude; z,w = range
		float2 ofsB;

		float2 sinPos(float2 uv, float2 amp, float2 ofs, float2 rng) {
			return float2(
				(uv).x + sin((uv).y * (rng).x + (ofs).x) * (amp).x,
				(uv).y + sin((uv).x * (rng).y + (ofs).y) * (amp).y);
		}

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float2 posR = sinPos(i.texcoord, parmsR.xy, ofsR, parmsR.zw);
			float2 posG = sinPos(i.texcoord, parmsG.xy, ofsG, parmsG.zw);
			float2 posB = sinPos(i.texcoord, parmsB.xy, ofsB, parmsB.zw);

			return float4(
				SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, posR).r,
				SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, posG).g,
				SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, posB).b,
				SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord).a);
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