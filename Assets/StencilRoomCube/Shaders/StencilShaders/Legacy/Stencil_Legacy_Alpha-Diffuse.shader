// MIT License
//
// Copyright (c) 2017 Noisecrime
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

Shader "Stencils/Legacy Shaders/Transparent/Diffuse"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
        [Toggle] _UseCutout ("Use Alpha Cutout", Float) = 0

        _StencilReferenceID("Stencil ID Reference", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil Comparison", Float) = 3    // equal
        [Enum(UnityEngine.Rendering.StencilOp)]      _StencilOp("Stencil Operation", Float) = 0       // keep
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
    }

    SubShader
    {
        Tags
        {
            "Queue"             = "Transparent"            
            "RenderType"        = "StencilTransparent"
            "IgnoreProjector"   = "True"
        }

        LOD 200

        Stencil
        {
            Ref[_StencilReferenceID]
            Comp[_StencilComp]    
            Pass[_StencilOp]    
            ReadMask[_StencilReadMask]
            WriteMask[_StencilWriteMask]
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade keepalpha
        #pragma shader_feature _USECUTOUT_ON

        sampler2D _MainTex;
        fixed4 _Color;
        float _Cutoff;
        float _UseCutout;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            
            #if _USECUTOUT_ON
                clip(c.a - _Cutoff);
                o.Alpha = 1;
            #else
                o.Alpha = c.a;
            #endif
        }
        ENDCG
    }

    Fallback "Transparent/VertexLit"
}