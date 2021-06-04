﻿/*
 *  The MIT License
 *
 *  Copyright 2018-2021 whiteflare.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 *  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
Shader "UnlitWF_URP/WF_Gem_Transparent" {

    Properties {
        // 基本
        [WFHeader(Gem Surface)]
        [HDR]
            _Color                  ("Color", Color) = (0.8, 0.4, 0.4, 1)
            _MainTex                ("Main Texture", 2D) = "white" {}
            _AlphaFront             ("Transparency (front)", Range(0, 1)) = 0.5
        [Enum(OFF,0,FRONT,1,BACK,2)]
            _CullMode               ("Cull Mode", int) = 2
        [Toggle(_)]
            _UseVertexColor         ("Use Vertex Color", Range(0, 1)) = 0

        // Flake
        [WFHeaderToggle(Gem Flake)]
            _GF_Enable              ("[GF] Enable", Float) = 1
        [PowerSlider(2.0)]
            _GF_FlakeSizeFront      ("[GF] Flake Size (front)", Range(0, 1)) = 0.1
            _GF_FlakeShear          ("[GF] Shear", Range(0, 1)) = 0.5
            _GF_FlakeBrighten       ("[GF] Brighten", Range(0, 8)) = 2
            _GF_FlakeDarken         ("[GF] Darken", Range(0, 8)) = 0.5
            _GF_Twinkle             ("[GF] Twinkle", Range(0, 4)) = 2
            _GF_BlendNormal         ("[GF] Blend Normal", Range(0, 1)) = 0.1

        // Reflection
        [WFHeaderToggle(Gem Reflection)]
            _GR_Enable              ("[GR] Enable", Float) = 1
            _GR_Power               ("[GR] Blend Power", Range(0, 1)) = 1
        [NoScaleOffset]
            _GR_Cubemap             ("[GR] CubeMap", Cube) = "" {}
            _GR_Brightness          ("[GR] Brightness", Range(0, 1)) = 0
            _GR_Monochrome          ("[GR] Monochrome Reflection", Range(0, 1)) = 1
            _GR_CubemapPower        ("[GR] 2nd CubeMap Power", Range(0, 2)) = 1
            _GR_CubemapHighCut      ("[GR] 2nd CubeMap Hi-Cut Filter", Range(0, 1)) = 0
            _GR_BlendNormal         ("[GR] Blend Normal", Range(0, 1)) = 0.1

        // Alpha
        [WFHeader(Transparent Alpha)]
        [WF_FixNoTexture]
            _AL_MaskTex             ("[AL] Alpha Mask Texture", 2D) = "white" {}
        [HideInInspector]
        [WF_FixFloat(0.0)]
            _AL_Source              ("[AL] Alpha Source", Float) = 0
        [HideInInspector]
        [WF_FixFloat(0.0)]
            _AL_InvMaskVal          ("[AL] Invert Mask Value", Range(0, 1)) = 0
            _AL_Power               ("[AL] Power", Range(0, 2)) = 0.8
            _AL_Fresnel             ("[AL] Fresnel Power", Range(0, 2)) = 1
        [Enum(OFF,0,ON,1)]
            _AL_ZWrite              ("[AL] ZWrite", int) = 0

        // 法線マップ
        [WFHeaderToggle(NormalMap)]
            _NM_Enable              ("[NM] Enable", Float) = 0
        [NoScaleOffset]
            _BumpMap                ("[NM] NormalMap Texture", 2D) = "bump" {}
            _BumpScale              ("[NM] Bump Scale", Range(0, 2)) = 1.0
        [Enum(NONE,0,X,1,Y,2,XY,3)]
            _NM_FlipMirror          ("[NM] Flip Mirror", Float) = 0

        // Lit
        [WFHeader(Lit)]
        [Gamma]
            _GL_LevelMin            ("Darken (min value)", Range(0, 1)) = 0.125
        [Gamma]
            _GL_LevelMax            ("Lighten (max value)", Range(0, 1)) = 0.8
            _GL_BlendPower          ("Blend Light Color", Range(0, 1)) = 0.8

        [WFHeader(Lit Advance)]
        [Enum(AUTO,0,ONLY_DIRECTIONAL_LIT,1,ONLY_POINT_LIT,2,CUSTOM_WORLDSPACE,3,CUSTOM_LOCALSPACE,4)]
            _GL_LightMode           ("Sun Source", Float) = 0
            _GL_CustomAzimuth       ("Custom Sun Azimuth", Range(0, 360)) = 0
            _GL_CustomAltitude      ("Custom Sun Altitude", Range(-90, 90)) = 45
        [Toggle(_)]
            _GL_DisableBackLit      ("Disable BackLit", Range(0, 1)) = 0
        [Toggle(_)]
            _GL_DisableBasePos      ("Disable ObjectBasePos", Range(0, 1)) = 0

        [HideInInspector]
        [WF_FixFloat(0.0)]
            _CurrentVersion         ("2021/05/15", Float) = 0
    }

    SubShader {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "LightweightPipeline"
        }

        Pass {
            Name "MAIN"
            Tags { "LightMode" = "LightweightForward" }

            Cull [_CullMode]

            ZWrite [_AL_ZWrite]
            Blend One OneMinusSrcAlpha

            HLSLPROGRAM

            #pragma exclude_renderers d3d11_9x gles

            #pragma vertex vert
            #pragma fragment frag_gem_front

            #pragma target 3.0

            #define _WF_ALPHA_FRESNEL
            #define _WF_MOBILE
            #define _WF_PLATFORM_LWRP

            #define _NM_ENABLE
            #define _VC_ENABLE

            // -------------------------------------
            // Lightweight Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            #pragma multi_compile_instancing

            #include "../WF_INPUT_Gem.cginc"
            #include "../WF_Gem.cginc"

            ENDHLSL
        }

        Pass {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite [_AL_ZWrite]
            ColorMask 0
            Cull[_CullMode]

            HLSLPROGRAM

            #pragma exclude_renderers d3d11_9x gles

            #pragma vertex vert_depth
            #pragma fragment frag_depth

            #define _WF_ALPHA_BLEND
            #define _WF_MOBILE
            #define _WF_PLATFORM_LWRP

            #define _VC_ENABLE

            #pragma multi_compile_instancing

            #include "../WF_INPUT_Gem.cginc"
            #include "../WF_UnToon_DepthOnly.cginc"

            ENDHLSL
        }
    }

    FallBack "Hidden/InternalErrorShader"

    CustomEditor "UnlitWF.ShaderCustomEditor"
}
