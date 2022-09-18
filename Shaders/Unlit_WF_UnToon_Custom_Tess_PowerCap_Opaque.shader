﻿/*
 *  The MIT License
 *
 *  Copyright 2018-2022 whiteflare.
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
Shader "UnlitWF/Custom/WF_UnToon_Custom_Tess_PowerCap_Opaque" {

    Properties {
        // 基本
        [WFHeader(Base)]
            _MainTex                ("Main Texture", 2D) = "white" {}
        [HDR]
            _Color                  ("Color", Color) = (1, 1, 1, 1)
        [Enum(OFF,0,FRONT,1,BACK,2)]
            _CullMode               ("Cull Mode", int) = 2
        [Toggle(_)]
            _UseVertexColor         ("Use Vertex Color", Range(0, 1)) = 0

        // Tessellation
        [WFHeader(Tessellation)]
        [IntRange]
            _TE_Factor              ("[TE] Tess Factor", Range(1, 16)) = 4
            _TE_SmoothPower         ("[TE] Smoothing", Range(0, 2)) = 1.0
        [NoScaleOffset]
            _TE_SmoothPowerTex      ("[TE] Smoothing Mask Texture (R)", 2D) = "white" {}
        [Toggle(_)]
            _TE_InvMaskVal          ("[TE] Invert Mask Value", Float) = 0
            _TE_MinDist             ("[TE] FadeOut Distance (Near)", Range(0, 4)) = 0.5
            _TE_MaxDist             ("[TE] FadeOut Distance (Far)", Range(0, 4)) = 2

        // アウトライン
        [WFHeaderToggle(Outline)]
            _TL_Enable              ("[TL] Enable", Float) = 0
            _TL_LineColor           ("[TL] Line Color", Color) = (0.1, 0.1, 0.1, 1)
        [NoScaleOffset]
            _TL_CustomColorTex      ("[TL] Custom Color Texture", 2D) = "white" {}
            _TL_LineWidth           ("[TL] Line Width", Range(0, 1)) = 0.05
            _TL_BlendCustom         ("[TL] Blend Custom Color Texture", Range(0, 1)) = 0
            _TL_BlendBase           ("[TL] Blend Base Color", Range(0, 1)) = 0
        [NoScaleOffset]
            _TL_MaskTex             ("[TL] Mask Texture (R)", 2D) = "white" {}
        [Toggle(_)]
            _TL_InvMaskVal          ("[TL] Invert Mask Value", Float) = 0
            _TL_Z_Shift             ("[TL] Z-shift (tweak)", Range(-0.1, 0.5)) = 0

        // 裏面テクスチャ
        [WFHeaderToggle(BackFace Texture)]
            _BKT_Enable             ("[BKT] Enable", Float) = 0
        [Enum(UV1,0,UV2,1)]
            _BKT_UVType             ("[BKT] UV Type", Float) = 0
            _BKT_BackTex            ("[BKT] Back Texture", 2D) = "white" {}
        [HDR]
            _BKT_BackColor          ("[BKT] Back Color", Color) = (1, 1, 1, 1)

        // 3chカラーマスク
        [WFHeaderToggle(3ch Color Mask)]
            _CHM_Enable             ("[CHM] Enable", Float) = 0
        [NoScaleOffset]
            _CHM_3chMaskTex         ("[CHM] 3ch Mask Texture", 2D) = "black" {}
        [HDR]
            _CHM_ColorR             ("[CHM] R ch Color", Color) = (1, 1, 1, 1)
        [HDR]
            _CHM_ColorG             ("[CHM] G ch Color", Color) = (1, 1, 1, 1)
        [HDR]
            _CHM_ColorB             ("[CHM] B ch Color", Color) = (1, 1, 1, 1)

        // 色変換
        [WFHeaderToggle(Color Change)]
            _CLC_Enable             ("[CLC] Enable", Float) = 0
        [Toggle(_)]
            _CLC_Monochrome         ("[CLC] monochrome", Range(0, 1)) = 0
            _CLC_DeltaH             ("[CLC] Hur", Range(0, 1)) = 0
            _CLC_DeltaS             ("[CLC] Saturation", Range(-1, 1)) = 0
            _CLC_DeltaV             ("[CLC] Brightness", Range(-1, 1)) = 0

        // ノーマルマップ
        [WFHeaderToggle(NormalMap)]
            _NM_Enable              ("[NM] Enable", Float) = 0
        [NoScaleOffset]
            _BumpMap                ("[NM] NormalMap Texture", 2D) = "bump" {}
            _BumpScale              ("[NM] Bump Scale", Range(0, 2)) = 1.0
            _NM_Power               ("[NM] Shadow Power", Range(0, 1)) = 0.25
        [Enum(NONE,0,X,1,Y,2,XY,3)]
            _FlipMirror             ("[NM] Flip Mirror", Float) = 0

        // Detailノーマルマップ
        [WFHeaderToggle(Detail NormalMap)]
            _NS_Enable              ("[NS] Enable", Float) = 0
        [Enum(UV1,0,UV2,1)]
            _NS_UVType              ("[NS] 2nd Normal UV Type", Float) = 0
            _DetailNormalMap        ("[NS] 2nd NormalMap Texture", 2D) = "bump" {}
            _DetailNormalMapScale   ("[NS] 2nd Bump Scale", Range(0, 2)) = 0.4
        [NoScaleOffset]
            _NS_2ndMaskTex          ("[NS] 2nd NormalMap Mask Texture (R)", 2D) = "white" {}
        [Toggle(_)]
            _NS_InvMaskVal          ("[NS] Invert Mask Value", Range(0, 1)) = 0

        // Matcapハイライト
        [WFHeaderToggle(Light Matcap)]
            _HL_Enable              ("[HL] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType             ("[HL] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex           ("[HL] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor         ("[HL] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power               ("[HL] Power", Range(0, 2)) = 1
            _HL_BlendNormal         ("[HL] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2        ("[HL] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex             ("[HL] Mask Texture (RGB)", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal          ("[HL] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax            ("[HL] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome    ("[HL] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor         ("[HL] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        [WFHeaderToggle(Light Matcap 2)]
            _HL_Enable_1            ("[HA] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType_1           ("[HA] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex_1         ("[HA] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor_1       ("[HA] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power_1             ("[HA] Power", Range(0, 2)) = 1
            _HL_BlendNormal_1       ("[HA] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2_1      ("[HA] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex_1           ("[HA] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal_1        ("[HA] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax_1          ("[HA] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome_1  ("[HA] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor_1       ("[HA] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        [WFHeaderToggle(Light Matcap 3)]
            _HL_Enable_2            ("[HB] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType_2           ("[HB] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex_2         ("[HB] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor_2       ("[HB] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power_2             ("[HB] Power", Range(0, 2)) = 1
            _HL_BlendNormal_2       ("[HB] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2_2      ("[HB] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex_2           ("[HB] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal_2        ("[HB] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax_2          ("[HB] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome_2  ("[HB] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor_2       ("[HB] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        [WFHeaderToggle(Light Matcap 4)]
            _HL_Enable_3            ("[HC] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType_3           ("[HC] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex_3         ("[HC] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor_3       ("[HC] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power_3             ("[HC] Power", Range(0, 2)) = 1
            _HL_BlendNormal_3       ("[HC] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2_3      ("[HC] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex_3           ("[HC] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal_3        ("[HC] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax_3          ("[HC] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome_3  ("[HC] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor_3       ("[HC] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        [WFHeaderToggle(Light Matcap 5)]
            _HL_Enable_4            ("[HD] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType_4           ("[HD] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex_4         ("[HD] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor_4       ("[HD] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power_4             ("[HD] Power", Range(0, 2)) = 1
            _HL_BlendNormal_4       ("[HD] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2_4      ("[HD] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex_4           ("[HD] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal_4        ("[HD] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax_4          ("[HD] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome_4  ("[HD] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor_4       ("[HD] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        [WFHeaderToggle(Light Matcap 6)]
            _HL_Enable_5            ("[HE] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType_5           ("[HE] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex_5         ("[HE] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor_5       ("[HE] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power_5             ("[HE] Power", Range(0, 2)) = 1
            _HL_BlendNormal_5       ("[HE] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2_5      ("[HE] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex_5           ("[HE] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal_5        ("[HE] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax_5          ("[HE] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome_5  ("[HE] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor_5       ("[HE] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        [WFHeaderToggle(Light Matcap 7)]
            _HL_Enable_6            ("[HF] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType_6           ("[HF] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex_6         ("[HF] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor_6       ("[HF] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power_6             ("[HF] Power", Range(0, 2)) = 1
            _HL_BlendNormal_6       ("[HF] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2_6      ("[HF] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex_6           ("[HF] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal_6        ("[HF] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax_6          ("[HF] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome_6  ("[HF] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor_6       ("[HF] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        [WFHeaderToggle(Light Matcap 8)]
            _HL_Enable_7            ("[HG] Enable", Float) = 0
        [Enum(MEDIAN_CAP,0,LIGHT_CAP,1,SHADE_CAP,2)]
            _HL_CapType_7           ("[HG] Matcap Type", Float) = 0
        [NoScaleOffset]
            _HL_MatcapTex_7         ("[HG] Matcap Sampler", 2D) = "gray" {}
            _HL_MedianColor_7       ("[HG] Matcap Base Color", Color) = (0.5, 0.5, 0.5, 1)
            _HL_Power_7             ("[HG] Power", Range(0, 2)) = 1
            _HL_BlendNormal_7       ("[HG] Blend Normal", Range(0, 1)) = 0.1
            _HL_BlendNormal2_7      ("[HG] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _HL_MaskTex_7           ("[HG] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _HL_InvMaskVal_7        ("[HG] Invert Mask Value", Range(0, 1)) = 0
        [Header(Matcap Advance)]
            _HL_Parallax_7          ("[HG] Parallax", Range(0, 1)) = 0.75
            _HL_MatcapMonochrome_7  ("[HG] Matcap Monochrome", Range(0, 1)) = 0
            _HL_MatcapColor_7       ("[HG] Matcap Tint Color", Color) = (0.5, 0.5, 0.5, 1)

        // 階調影
        [WFHeaderToggle(ToonShade)]
            _TS_Enable              ("[TS] Enable", Float) = 0
        [IntRange]
            _TS_Steps               ("[TS] Steps", Range(1, 3)) = 2
            _TS_BaseColor           ("[TS] Base Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]
            _TS_BaseTex             ("[TS] Base Shade Texture", 2D) = "white" {}
            _TS_1stColor            ("[TS] 1st Shade Color", Color) = (0.81, 0.81, 0.9, 1)
        [NoScaleOffset]
            _TS_1stTex              ("[TS] 1st Shade Texture", 2D) = "white" {}
            _TS_2ndColor            ("[TS] 2nd Shade Color", Color) = (0.68, 0.68, 0.8, 1)
        [NoScaleOffset]
            _TS_2ndTex              ("[TS] 2nd Shade Texture", 2D) = "white" {}
            _TS_3rdColor            ("[TS] 3rd Shade Color", Color) = (0.595, 0.595, 0.7, 1)
        [NoScaleOffset]
            _TS_3rdTex              ("[TS] 3rd Shade Texture", 2D) = "white" {}
            _TS_Power               ("[TS] Shade Power", Range(0, 2)) = 1
            _TS_MinDist             ("[TS] FadeOut Distance (Near)", Range(0, 15)) = 1.0
            _TS_MaxDist             ("[TS] FadeOut Distance (Far)", Range(0, 15)) = 4.0
        [Toggle(_)]
            _TS_FixContrast         ("[TS] Dont Ajust Contrast", Range(0, 1)) = 0
            _TS_BlendNormal         ("[TS] Blend Normal", Range(0, 1)) = 0.1
            _TS_BlendNormal2        ("[TS] Blend Normal 2nd", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _TS_MaskTex             ("[TS] Anti-Shadow Mask Texture (R)", 2D) = "black" {}
        [Toggle(_)]
            _TS_InvMaskVal          ("[TS] Invert Mask Value", Range(0, 1)) = 0
        [Header(ToonShade Advance)]
            _TS_1stBorder           ("[TS] 1st Border", Range(0, 1)) = 0.4
            _TS_2ndBorder           ("[TS] 2nd Border", Range(0, 1)) = 0.2
            _TS_3rdBorder           ("[TS] 3rd Border", Range(0, 1)) = 0.1
            _TS_1stFeather          ("[TS] 1st Feather", Range(0, 0.2)) = 0.05
            _TS_2ndFeather          ("[TS] 2nd Feather", Range(0, 0.2)) = 0.05
            _TS_3rdFeather          ("[TS] 3rd Feather", Range(0, 0.2)) = 0.05

        // リムライト
        [WFHeaderToggle(RimLight)]
            _TR_Enable              ("[TR] Enable", Float) = 0
        [HDR]
            _TR_Color               ("[TR] Rim Color", Color) = (0.8, 0.8, 0.8, 1)
        [Enum(ADD,2,ALPHA,1,ADD_AND_SUB,0)]
            _TR_BlendType           ("[TR] Blend Type", Float) = 0
            _TR_Power               ("[TR] Power", Range(0, 2)) = 1
            _TR_Feather             ("[TR] Feather", Range(0, 0.2)) = 0.05
            _TR_BlendNormal         ("[TR] Blend Normal", Range(0, 1)) = 0
            _TR_BlendNormal2        ("[TR] Blend Normal 2nd", Range(0, 1)) = 0
        [NoScaleOffset]
            _TR_MaskTex             ("[TR] Mask Texture (RGB)", 2D) = "white" {}
        [Toggle(_)]
            _TR_InvMaskVal          ("[TR] Invert Mask Value", Range(0, 1)) = 0
        [Header(RimLight Advance)]
            _TR_PowerTop            ("[TR] Power Top", Range(0, 0.5)) = 0.05
            _TR_PowerSide           ("[TR] Power Side", Range(0, 0.5)) = 0.1
            _TR_PowerBottom         ("[TR] Power Bottom", Range(0, 0.5)) = 0.1

        // Lit
        [WFHeader(Lit)]
        [Gamma]
            _GL_LevelMin            ("Unlit Intensity", Range(0, 1)) = 0.125
        [Gamma]
            _GL_LevelMax            ("Saturate Intensity", Range(0, 1)) = 0.8
            _GL_BlendPower          ("Chroma Reaction", Range(0, 1)) = 0.8
        [Toggle(_)]
            _GL_CastShadow          ("Cast Shadows", Range(0, 1)) = 1

        [WFHeader(Lit Advance)]
        [Enum(AUTO,0,ONLY_DIRECTIONAL_LIT,1,ONLY_POINT_LIT,2,CUSTOM_WORLD_DIR,3,CUSTOM_LOCAL_DIR,4,CUSTOM_WORLD_POS,5)]
            _GL_LightMode           ("Sun Source", Float) = 0
            _GL_CustomAzimuth       ("Custom Sun Azimuth", Range(0, 360)) = 0
            _GL_CustomAltitude      ("Custom Sun Altitude", Range(-90, 90)) = 45
        [WF_Vector3]
            _GL_CustomLitPos        ("Custom Light Pos", Vector) = (0, 3, 0)
        [Toggle(_)]
            _GL_DisableBackLit      ("Disable BackLit", Range(0, 1)) = 0
        [Toggle(_)]
            _GL_DisableBasePos      ("Disable ObjectBasePos", Range(0, 1)) = 0

        [WFHeaderToggle(Light Bake Effects)]
            _LBE_Enable             ("[LBE] Enable", Float) = 0
            _LBE_IndirectMultiplier ("[LBE] Indirect Multiplier", Range(0, 2)) = 1
            _LBE_EmissionMultiplier ("[LBE] Emission Multiplier", Range(0, 2)) = 1
            _LBE_IndirectChroma     ("[LBE] Indirect Chroma", Range(0, 2)) = 1

        [HideInInspector]
        [WF_FixFloat(0.0)]
            _CurrentVersion         ("2022/08/13", Float) = 0
        [HideInInspector]
        [WF_FixFloat(0.0)]
            _FallBack               ("UnlitWF/WF_UnToon_Opaque", Float) = 0
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "DisableBatching" = "True"
            "VRCFallback" = "Unlit"
        }

        Pass {
            Name "OUTLINE"
            Tags { "LightMode" = "ForwardBase" }

            Cull FRONT

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hull
            #pragma domain domain_outline

            #pragma target 5.0

            #define _WF_UNTOON_TESS


            #define _TL_ENABLE
            #define _VC_ENABLE

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma skip_variants SHADOWS_SCREEN SHADOWS_CUBE SHADOWS_SHADOWMASK

            #include "WF_UnToon_Tessellation.cginc"

            ENDCG
        }

        Pass {
            Name "MAIN"
            Tags { "LightMode" = "ForwardBase" }

            Cull [_CullMode]

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma hull hull
            #pragma domain domain

            #pragma target 5.0

            #define _WF_UNTOON_TESS
            #define _WF_UNTOON_POWERCAP



            #define _NM_ENABLE
            #define _NS_ENABLE
            #define _TS_ENABLE
            #define _VC_ENABLE

            #define _BKT_ENABLE
            #define _CHM_ENABLE
            #define _HL_ENABLE
            #define _TR_ENABLE

            #define _HL_ENABLE_1
            #define _HL_ENABLE_2
            #define _HL_ENABLE_3
            #define _HL_ENABLE_4
            #define _HL_ENABLE_5
            #define _HL_ENABLE_6
            #define _HL_ENABLE_7

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma skip_variants SHADOWS_SCREEN SHADOWS_CUBE SHADOWS_SHADOWMASK

            #include "WF_UnToon_Tessellation.cginc"

            ENDCG
        }

        UsePass "UnlitWF/WF_UnToon_Opaque/SHADOWCASTER"
        UsePass "UnlitWF/WF_UnToon_Opaque/META"
    }

    FallBack "UnlitWF/WF_UnToon_Opaque"

    CustomEditor "UnlitWF.ShaderCustomEditor"
}
