Shader "Hidden/M8/PostProcessEffects/Wave"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float4 parms; // x,y = amplitude; z,w = range
		float2 speed;

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float2 pos = float2(
				i.texcoord.x + sin(i.texcoord.y * parms.z + speed.x * _Time.y) * parms.x,
				i.texcoord.y + sin(i.texcoord.x * parms.w + speed.y * _Time.y) * parms.y);

			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, pos);

			return color;
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