/*
 *    Dot 'n bloom shader
 *    Author: Themaister
 *    License: Public domain
 *
 *    Direct3D port by gulikoza at users.sourceforge.net
 *
 */
Shader "Hidden/M8/PostProcessEffects/DotBloom"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		struct VaryingsDotBloom
		{
			float4 vertex : SV_POSITION;

			float2 uv : TEXCOORD0;
			float2 pixel_no	: TEXCOORD1;
			float2 pixel_s	: TEXCOORD2;
		};

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
		uniform float4 _MainTex_TexelSize;

		float gamma = 2.4;
		float shine = 0.05;
		float blend = 0.65;

		float dist(float2 coord, float2 source)
		{
			float2 delta = coord - source;
			return sqrt(dot(delta, delta));
		}

		float color_bloom(float4 color)
		{
			const float3 gray_coeff = float3(0.30, 0.59, 0.11);
			float bright = dot(color.rgb, gray_coeff);
			return lerp(1.0 + shine, 1.0 - shine, bright);
		}

		float4 lookup(float2 offset, float2 coord, float2 pixel_no)
		{
			float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, coord);
			float delta = dist(frac(pixel_no), offset + float2(0.5, 0.5));
			return color * exp(-gamma * delta * color_bloom(color));
		}

		#define OFFSET(c)		c, i.uv + (c * i.pixel_s), i.pixel_no

		VaryingsDotBloom Vert(AttributesDefault v)
		{
			VaryingsDotBloom o;
			o.vertex = float4(v.vertex.xy, 0.0, 1.0);

			float2 uv = TransformTriangleVertexToUV(v.vertex.xy);

#if UNITY_UV_STARTS_AT_TOP
			uv = uv * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif

			o.uv = uv;
			o.pixel_no = uv * _MainTex_TexelSize.zw;
			o.pixel_s = _MainTex_TexelSize.xx;

			return o;
		}

		float4 Frag(VaryingsDotBloom i) : SV_Target
		{
			float4 color = float4(0.0, 0.0, 0.0, 0.0);
			float4 mid_color = lookup(OFFSET(float2(0.0, 0.0)));

			color += lookup(OFFSET(float2(-1.0, -1.0)));
			color += lookup(OFFSET(float2(0.0, -1.0)));
			color += lookup(OFFSET(float2(1.0, -1.0)));
			color += lookup(OFFSET(float2(-1.0,  0.0)));
			color += mid_color;
			color += lookup(OFFSET(float2(1.0,  0.0)));
			color += lookup(OFFSET(float2(-1.0,  1.0)));
			color += lookup(OFFSET(float2(0.0,  1.0)));
			color += lookup(OFFSET(float2(1.0,  1.0)));

			return lerp(1.2 * mid_color, color, blend);
		}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			HLSLPROGRAM
				#pragma vertex Vert
				#pragma fragment Frag
			ENDHLSL
		}
	}
}