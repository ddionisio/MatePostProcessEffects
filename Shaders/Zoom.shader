Shader "Hidden/M8/PostProcessEffects/Zoom"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float4 parms; //(x, y, amount)

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float2 pos = (i.texcoord - parms.xy) * parms.z + parms.xy;

			return SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, pos);
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