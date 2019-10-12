Shader "Hidden/M8/PostProcessEffects/Tile"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float numTiles;

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float size = 1.0 / numTiles;
			float2 pBase = i.texcoord - fmod(i.texcoord, size.xx);
			float2 pCenter = pBase + (size / 2.0).xx;

			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, pCenter);

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