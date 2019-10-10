Shader "Hidden/M8/PostProcessEffects/Dither"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
		#include "Dither.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

		float4 Frag(VaryingsDefault i) : SV_Target
		{
			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			float dither = genDither(i.texcoord);//lerp(0, genDither(i.texcoord), blend);

			return float4(color.r + dither, color.g + dither, color.b + dither, color.a);
		}

		sampler2D _WeightTex;

		float4 FragWeight(VaryingsDefault i) : SV_Target
		{
			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

			float colorLumen = dot(color.rgb, float3(0.2126729, 0.7151522, 0.0721750)); //simple grayscale

			float dither = lerp(0, genDither(i.texcoord), tex2D(_WeightTex, float2(colorLumen, 0)).r);

			return float4(color.r + dither, color.g + dither, color.b + dither, color.a);
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

		Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment FragWeight
			ENDHLSL
		}
	}
}