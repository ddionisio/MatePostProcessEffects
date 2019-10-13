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

  The shader tries to make a "colored sketch" of the screen that is currently being
  drawn.

*/
Shader "Hidden/M8/PostProcessEffects/SketchColor"
{
	HLSLINCLUDE
		#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		struct VaryingsSketch
		{
			float4 vertex : SV_POSITION;

			float2  CT   : TEXCOORD0;
			float4  t1   : TEXCOORD1;
			float4  t2   : TEXCOORD2;
			float4  t3   : TEXCOORD3;
			float4  t4   : TEXCOORD4;
		};

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
		uniform float4 _MainTex_TexelSize;

		float4 pap;
		float threshold;

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

			o.CT = uv;
			o.t1.xy = uv + float2(-dx, 0);
			o.t2.xy = uv + float2(dx, 0);
			o.t3.xy = uv + float2(0, -dy);
			o.t4.xy = uv + float2(0, dy);
			o.t1.zw = uv + float2(-dx, -dy);
			o.t2.zw = uv + float2(-dx, dy);
			o.t3.zw = uv + float2(dx, -dy);
			o.t4.zw = uv + float2(dx, dy);

			return o;
		}

		float4 Frag(VaryingsSketch i) : SV_Target
		{
			float3 c00 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t1.zw).xyz;
			float3 c10 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t3.xy).xyz;
			float3 c20 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t3.zw).xyz;
			float3 c01 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t1.xy).xyz;
			float4 c11 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.CT);
			float3 c21 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t2.xy).xyz;
			float3 c02 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t2.zw).xyz;
			float3 c12 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t4.xy).xyz;
			float3 c22 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.t4.zw).xyz;

			float3 dt = float3(1, 1, 1);

			float d1 = dot(abs(c00 - c22), dt);
			float d2 = dot(abs(c20 - c02), dt);
			float hl = dot(abs(c01 - c21), dt);
			float vl = dot(abs(c10 - c12), dt);

			float d = abs(0.55 * (d1 + d2 + hl + vl) / (dot(c11.xyz + c10 + c02 + c22, dt) + 0.3));
			d += 0.5 * pow(d, 0.5);
			c11 *= (1.0 - 0.6 * d); d += 0.1;
			d = pow(d, threshold - threshold * min(2.0 * d, 1.0));
			return d * c11 + (1.1 - d) * pap;
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