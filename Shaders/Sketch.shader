/*
   Copyright (C) 2006 guest(r) - guest.r@gmail.com

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

/*

  The shader tries to make a "BW sketch" of the screen that is currently being
  drawn.

*/
Shader "Hidden/M8/PostProcessEffects/Sketch"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		struct VaryingsSketch
		{
			float4 vertex : SV_POSITION;

			float2  C    : TEXCOORD0;
			float2  L    : TEXCOORD1;
			float2  R    : TEXCOORD2;
			float2  U    : TEXCOORD3;
			float2  D    : TEXCOORD4;
		};

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
		uniform float4 _MainTex_TexelSize;

		float blend;
		float4 pap;
		float4 ink;

		VaryingsSketch Vert(AttributesDefault v)
		{
			VaryingsSketch o;
			o.vertex = float4(v.vertex.xy, 0.0, 1.0);

			float2 uv = TransformTriangleVertexToUV(v.vertex.xy);

#if UNITY_UV_STARTS_AT_TOP
			uv = uv * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif

			float dx = _MainTex_TexelSize.x * 0.5;
			float dy = _MainTex_TexelSize.y * 0.5;

			o.C = uv;
			o.L = uv + float2(-dx, 0);
			o.R = uv + float2(dx, 0);
			o.U = uv + float2(0, -dy);
			o.D = uv + float2(0, dy);

			return o;
		}

		float4 GetColor(VaryingsSketch i)
		{
			float3 c11 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.C).xyz;
			float3 c01 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.L).xyz;
			float3 c21 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.R).xyz;
			float3 c10 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.U).xyz;
			float3 c12 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.D).xyz;

			float3 dt = float3(1, 1, 1);

			float lum_ct = dot(c11, dt) * 0.5 + 0.5;
			float lum_x = dot(c01 + c21, dt) * 0.2 + lum_ct;
			float lum_y = dot(c10 + c12, dt) * 0.2 + lum_ct;

			float d = dot(abs(c01 - c21), dt) / lum_x + dot(abs(c10 - c12), dt) / lum_y;
			float a = max(0.0, 3.0 * d - 0.15);

			return (1.0 - a) * pap + a * ink;
		}

		float4 Frag(VaryingsSketch i) : SV_Target
		{
			return GetColor(i);
		}

		float4 FragBlend(VaryingsSketch i) : SV_Target
		{
			float4 clr = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.C);

			return lerp(clr, GetColor(i), blend);
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

		Pass
		{
			HLSLPROGRAM
				#pragma vertex Vert
				#pragma fragment FragBlend
			ENDHLSL
		}
	}
}