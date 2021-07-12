/**************************
***** Compiler Parameters *****
***************************
@P EffectName: StrideForwardShadingEffect
@P   - StrideEffectBase.HasInstancing: False
@P Material.PixelStageSurfaceShaders: mixin MaterialSurfaceArray [{layers = [mixin MaterialSurfaceDiffuse [{diffuseMap = MaterialCompiling}], mixin MaterialSurfaceLightingAndShading [{surfaces = [MaterialSurfaceShadingDiffuseLambert<false>]}]]}]
@P Material.PixelStageStreamInitializer: mixin MaterialStream, MaterialPixelShadingStream
@P Lighting.EnvironmentLights: LightConstantWhite
***************************
****  ConstantBuffers  ****
***************************
cbuffer PerDraw [Size: 416]
@C    World_id31 => Transformation.World
@C    WorldInverse_id32 => Transformation.WorldInverse
@C    WorldInverseTranspose_id33 => Transformation.WorldInverseTranspose
@C    WorldView_id34 => Transformation.WorldView
@C    WorldViewInverse_id35 => Transformation.WorldViewInverse
@C    WorldViewProjection_id36 => Transformation.WorldViewProjection
@C    WorldScale_id37 => Transformation.WorldScale
@C    EyeMS_id38 => Transformation.EyeMS
cbuffer PerFrame [Size: 16]
@C    Time_id84 => Global.Time
@C    TimeStep_id85 => Global.TimeStep
cbuffer PerMaterial [Size: 32]
@C    OriginalColor_id144 => MaterialCompiling.OriginalColor.diffuseMap.layers[0].materialPixelStage
@C    HasTexture_id145 => MaterialCompiling.HasTexture.diffuseMap.layers[0].materialPixelStage
cbuffer PerView [Size: 352]
@C    View_id24 => Transformation.View
@C    ViewInverse_id25 => Transformation.ViewInverse
@C    Projection_id26 => Transformation.Projection
@C    ProjectionInverse_id27 => Transformation.ProjectionInverse
@C    ViewProjection_id28 => Transformation.ViewProjection
@C    ProjScreenRay_id29 => Transformation.ProjScreenRay
@C    Eye_id30 => Transformation.Eye
***************************
******  Resources    ******
***************************
@R    PerMaterial => PerMaterial [Stage: None, Slot: (-1--1)]
@R    OriginalTexture_id146 => MaterialCompiling.OriginalTexture [Stage: None, Slot: (-1--1)]
@R    OriginalTexture_id146 => MaterialCompiling.OriginalTexture [Stage: None, Slot: (-1--1)]
@R    PerDraw => PerDraw [Stage: Vertex, Slot: (0-0)]
@R    PerView => PerView [Stage: Vertex, Slot: (1-1)]
@R    LinearSampler_id116 => Texturing.LinearSampler [Stage: Pixel, Slot: (0-0)]
@R    OriginalTexture_id146 => MaterialCompiling.OriginalTexture [Stage: Pixel, Slot: (0-0)]
@R    PerFrame => PerFrame [Stage: Pixel, Slot: (0-0)]
@R    PerMaterial => PerMaterial [Stage: Pixel, Slot: (1-1)]
***************************
*****     Sources     *****
***************************
@S    ShaderBase => 01e372056ff6c06edab8e988414a8f75
@S    ShaderBaseStream => 91c0ea8aae0a45ca00578a4084fa3607
@S    ShadingBase => ffb632df632721ce2c25f1b6f505fc1e
@S    ComputeColor => 4f34177c1ace328c0f5ae9b3e880dac2
@S    TransformationBase => 8b17025a11a061cbf806a590fecff713
@S    NormalStream => 901c352015317e9dff7f9aef777dc0c7
@S    TransformationWAndVP => 4852381ef91335cbf665eca43a0eb5ee
@S    PositionStream4 => 978c413387a2cb385e61d6d096be6d21
@S    PositionHStream4 => 6a2c2e4bcfc42de2c49c69f480ead970
@S    Transformation => 6c40fce14b58a620257103f7d0f4c093
@S    NormalFromMesh => d6eccd1ce6aae826e4049d4e94b581a4
@S    NormalBase => 3e598ef48925debde0053f3469205f5f
@S    NormalUpdate => a1cefe3f75303b1c5857928c714e12bf
@S    MaterialSurfacePixelStageCompositor => 69d0c95661b93268f264d740adf7b8f4
@S    PositionStream => f29f571241be3db9dd2ec9688eb1db49
@S    MaterialPixelShadingStream => 9d583be145776e49c5a8377a978b0658
@S    MaterialPixelStream => ba54d20041c3b54e07f20babb85f60bb
@S    MaterialStream => 5add3babbb46e617235ca05953485ed8
@S    IStreamInitializer => 092b60c9fe32ce985421fcfe20a11072
@S    LightStream => 56c38b50a16fcb778c6eb6de86c307b5
@S    DirectLightGroupArray => eb6e08e566ca745bb06964c172175969
@S    DirectLightGroup => f340deae83183fca86789915a8f743c4
@S    ShadowGroup => 05578eeca4469db17e4a68e127e25a9f
@S    ShadowStream => 1adfec0b15bc9bf4d56e6be9b378a587
@S    TextureProjectionGroup => 48db91a31cbf2a9150d13547051adb85
@S    EnvironmentLightArray => 02bffee7c5265d75553f30029f1fbf48
@S    EnvironmentLight => aec79836f4a6429ad55d8efc9971a8d7
@S    IMaterialSurface => 993d0e1a3a0209ce4df727250c905ab8
@S    LightConstantWhite => 908ef9d20842056edb7256edab7d3f0c
@S    MaterialSurfaceArray => 6c056e27887290fe2f9862991714228f
@S    MaterialSurfaceDiffuse => 4130aff8a17174b1b1457299185be45e
@S    IMaterialSurfacePixel => efa5da7adb861031599778e9829daca8
@S    MaterialCompiling => 932f0dd13b0b368363ea1e841593644d
@S    Global => 9f1e0462aa3fb62f0ff0d7a537626a5a
@S    Texturing => 6605f68230266eff2bc8b4e8102ede6b
@S    MaterialSurfaceLightingAndShading => 56a8877cd2af395727b11f69c761ad41
@S    Math => 395aa210901b9e0783594d1b4fb0a441
@S    IMaterialSurfaceShading => 86261e2a0ca0229f0d6ddf87490e5967
@S    MaterialSurfaceShadingDiffuseLambert => 9adb7783d6ea173f9f8ffdfa5c141256
***************************
*****     Stages      *****
***************************
@G    Vertex => d401b243ae289c87252688529da57c6a
//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer PerDraw
// {
//
//   float4x4 World_id31;               // Offset:    0 Size:    64
//   float4x4 WorldInverse_id32;        // Offset:   64 Size:    64 [unused]
//   float4x4 WorldInverseTranspose_id33;// Offset:  128 Size:    64
//   float4x4 WorldView_id34;           // Offset:  192 Size:    64 [unused]
//   float4x4 WorldViewInverse_id35;    // Offset:  256 Size:    64 [unused]
//   float4x4 WorldViewProjection_id36; // Offset:  320 Size:    64 [unused]
//   float3 WorldScale_id37;            // Offset:  384 Size:    12 [unused]
//   float4 EyeMS_id38;                 // Offset:  400 Size:    16 [unused]
//
// }
//
// cbuffer PerView
// {
//
//   float4x4 View_id24;                // Offset:    0 Size:    64 [unused]
//   float4x4 ViewInverse_id25;         // Offset:   64 Size:    64 [unused]
//   float4x4 Projection_id26;          // Offset:  128 Size:    64 [unused]
//   float4x4 ProjectionInverse_id27;   // Offset:  192 Size:    64 [unused]
//   float4x4 ViewProjection_id28;      // Offset:  256 Size:    64
//   float2 ProjScreenRay_id29;         // Offset:  320 Size:     8 [unused]
//   float4 Eye_id30;                   // Offset:  336 Size:    16 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// PerDraw                           cbuffer      NA          NA            cb0      1 
// PerView                           cbuffer      NA          NA            cb1      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION                 0   xyzw        0     NONE   float   xyzw
// NORMAL                   0   xyz         1     NONE   float   xyz 
// TEXCOORD                 0   xy          2     NONE   float   xy  
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION_WS              0   xyzw        0     NONE   float   xyzw
// SV_Position              0   xyzw        1      POS   float   xyzw
// NORMALWS                 0   xyz         2     NONE   float   xyz 
// TEXCOORD                 0   xy          3     NONE   float   xy  
//
vs_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[11], immediateIndexed
dcl_constantbuffer CB1[20], immediateIndexed
dcl_input v0.xyzw
dcl_input v1.xyz
dcl_input v2.xy
dcl_output o0.xyzw
dcl_output_siv o1.xyzw, position
dcl_output o2.xyz
dcl_output o3.xy
dcl_temps 1
//
// Initial variable locations:
//   v0.x <- __input__.Position_id20.x; v0.y <- __input__.Position_id20.y; v0.z <- __input__.Position_id20.z; v0.w <- __input__.Position_id20.w; 
//   v1.x <- __input__.meshNormal_id15.x; v1.y <- __input__.meshNormal_id15.y; v1.z <- __input__.meshNormal_id15.z; 
//   v2.x <- __input__.TexCoord_id134.x; v2.y <- __input__.TexCoord_id134.y; 
//   o3.x <- <VSMain return value>.TexCoord_id134.x; o3.y <- <VSMain return value>.TexCoord_id134.y; 
//   o2.x <- <VSMain return value>.normalWS_id18.x; o2.y <- <VSMain return value>.normalWS_id18.y; o2.z <- <VSMain return value>.normalWS_id18.z; 
//   o1.x <- <VSMain return value>.ShadingPosition_id0.x; o1.y <- <VSMain return value>.ShadingPosition_id0.y; o1.z <- <VSMain return value>.ShadingPosition_id0.z; o1.w <- <VSMain return value>.ShadingPosition_id0.w; 
//   o0.x <- <VSMain return value>.PositionWS_id21.x; o0.y <- <VSMain return value>.PositionWS_id21.y; o0.z <- <VSMain return value>.PositionWS_id21.z; o0.w <- <VSMain return value>.PositionWS_id21.w
//
#line 366 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_4460bb4e262944a5ca4e394f2cb4dc94.hlsl"
dp4 r0.x, v0.xyzw, cb0[0].xyzw  // r0.x <- streams.PositionWS_id21.x
dp4 r0.y, v0.xyzw, cb0[1].xyzw  // r0.y <- streams.PositionWS_id21.y
dp4 r0.z, v0.xyzw, cb0[2].xyzw  // r0.z <- streams.PositionWS_id21.z
dp4 r0.w, v0.xyzw, cb0[3].xyzw  // r0.w <- streams.PositionWS_id21.w

#line 435
mov o0.xyzw, r0.xyzw

#line 329
dp4 o1.x, r0.xyzw, cb1[16].xyzw
dp4 o1.y, r0.xyzw, cb1[17].xyzw
dp4 o1.z, r0.xyzw, cb1[18].xyzw
dp4 o1.w, r0.xyzw, cb1[19].xyzw

#line 401
dp3 o2.x, v1.xyzx, cb0[8].xyzx
dp3 o2.y, v1.xyzx, cb0[9].xyzx
dp3 o2.z, v1.xyzx, cb0[10].xyzx

#line 435
mov o3.xy, v2.xyxx
ret 
// Approximately 14 instruction slots used
@G    Pixel => 2c1d907a13bbc2d3cf838a0e40c5e45b
//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer PerFrame
// {
//
//   float Time_id84;                   // Offset:    0 Size:     4
//   float TimeStep_id85;               // Offset:    4 Size:     4 [unused]
//
// }
//
// cbuffer PerMaterial
// {
//
//   float4 OriginalColor_id144;        // Offset:    0 Size:    16
//   bool HasTexture_id145;             // Offset:   16 Size:     4
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// LinearSampler_id116               sampler      NA          NA             s0      1 
// OriginalTexture_id146             texture  float4          2d             t0      1 
// PerFrame                          cbuffer      NA          NA            cb0      1 
// PerMaterial                       cbuffer      NA          NA            cb1      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION_WS              0   xyzw        0     NONE   float       
// SV_Position              0   xyzw        1      POS   float       
// NORMALWS                 0   xyz         2     NONE   float       
// TEXCOORD                 0   xy          3     NONE   float   xy  
// SV_IsFrontFace           0   x           4    FFACE    uint       
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_Target                0   xyzw        0   TARGET   float   xyzw
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[1], immediateIndexed
dcl_constantbuffer CB1[2], immediateIndexed
dcl_sampler s0, mode_default
dcl_resource_texture2d (float,float,float,float) t0
dcl_input_ps linear v3.xy
dcl_output o0.xyzw
dcl_temps 3
//
// Initial variable locations:
//   v0.x <- __input__.PositionWS_id21.x; v0.y <- __input__.PositionWS_id21.y; v0.z <- __input__.PositionWS_id21.z; v0.w <- __input__.PositionWS_id21.w; 
//   v1.x <- __input__.ShadingPosition_id0.x; v1.y <- __input__.ShadingPosition_id0.y; v1.z <- __input__.ShadingPosition_id0.z; v1.w <- __input__.ShadingPosition_id0.w; 
//   v2.x <- __input__.normalWS_id18.x; v2.y <- __input__.normalWS_id18.y; v2.z <- __input__.normalWS_id18.z; 
//   v3.x <- __input__.TexCoord_id134.x; v3.y <- __input__.TexCoord_id134.y; 
//   v4.x <- __input__.IsFrontFace_id1; 
//   o0.x <- <PSMain return value>.ColorTarget_id2.x; o0.y <- <PSMain return value>.ColorTarget_id2.y; o0.z <- <PSMain return value>.ColorTarget_id2.z; o0.w <- <PSMain return value>.ColorTarget_id2.w
//
#line 259 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_4460bb4e262944a5ca4e394f2cb4dc94.hlsl"
mul r0.x, cb0[0].x, l(6.000000)
sincos r0.x, null, r0.x
mad r0.x, r0.x, l(0.250000), l(0.250000)  // r0.x <- factor

#line 260
sample_indexable(texture2d)(float,float,float,float) r1.xyzw, v3.xyxx, t0.xyzw, s0
movc r1.xyzw, cb1[1].xxxx, r1.xyzw, cb1[0].xyzw  // r1.x <- color.x; r1.y <- color.y; r1.z <- color.z; r1.w <- color.w

#line 262
add r2.xyzw, -r1.xyzw, l(0.250000, 1.000000, 0.250000, 1.000000)
mad o0.xyzw, r0.xxxx, r2.xyzw, r1.xyzw

#line 420
ret 
// Approximately 8 instruction slots used
***************************
*************************/
static const float PI_id149 = 3.14159265358979323846;
const static bool TIsEnergyConservative_id150 = false;
struct PS_STREAMS 
{
    float3 normalWS_id18;
    float4 PositionWS_id21;
    float2 TexCoord_id134;
    bool IsFrontFace_id1;
    float3 meshNormalWS_id16;
    float3 viewWS_id67;
    float3 shadingColor_id72;
    float matBlend_id39;
    float3 matNormal_id50;
    float4 matColorBase_id51;
    float4 matDiffuse_id52;
    float3 matDiffuseVisible_id68;
    float3 matSpecular_id54;
    float3 matSpecularVisible_id70;
    float matSpecularIntensity_id55;
    float matGlossiness_id53;
    float alphaRoughness_id69;
    float matAmbientOcclusion_id56;
    float matAmbientOcclusionDirectLightingFactor_id57;
    float matCavity_id58;
    float matCavityDiffuse_id59;
    float matCavitySpecular_id60;
    float4 matEmissive_id61;
    float matEmissiveIntensity_id62;
    float matScatteringStrength_id63;
    float2 matDiffuseSpecularAlphaBlend_id64;
    float3 matAlphaBlendColor_id65;
    float matAlphaDiscard_id66;
    float shadingColorAlpha_id73;
    float3 lightPositionWS_id40;
    float3 lightDirectionWS_id41;
    float3 lightColor_id42;
    float3 lightColorNdotL_id43;
    float3 lightSpecularColorNdotL_id44;
    float lightAttenuation_id45;
    float3 envLightDiffuseColor_id46;
    float3 envLightSpecularColor_id47;
    float lightDirectAmbientOcclusion_id49;
    float NdotL_id48;
    float NdotV_id71;
    float4 ColorTarget_id2;
};
struct PS_OUTPUT 
{
    float4 ColorTarget_id2 : SV_Target0;
};
struct PS_INPUT 
{
    float4 PositionWS_id21 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float3 normalWS_id18 : NORMALWS;
    float2 TexCoord_id134 : TEXCOORD0;
    bool IsFrontFace_id1 : SV_IsFrontFace;
};
struct VS_STREAMS 
{
    float4 Position_id20;
    float3 meshNormal_id15;
    float2 TexCoord_id134;
    float4 PositionH_id23;
    float DepthVS_id22;
    float3 meshNormalWS_id16;
    float4 PositionWS_id21;
    float4 ShadingPosition_id0;
    float3 normalWS_id18;
};
struct VS_OUTPUT 
{
    float4 PositionWS_id21 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float3 normalWS_id18 : NORMALWS;
    float2 TexCoord_id134 : TEXCOORD0;
};
struct VS_INPUT 
{
    float4 Position_id20 : POSITION;
    float3 meshNormal_id15 : NORMAL;
    float2 TexCoord_id134 : TEXCOORD0;
};
cbuffer PerDraw 
{
    float4x4 World_id31;
    float4x4 WorldInverse_id32;
    float4x4 WorldInverseTranspose_id33;
    float4x4 WorldView_id34;
    float4x4 WorldViewInverse_id35;
    float4x4 WorldViewProjection_id36;
    float3 WorldScale_id37;
    float4 EyeMS_id38;
};
cbuffer PerFrame 
{
    float Time_id84;
    float TimeStep_id85;
};
cbuffer PerMaterial 
{
    float4 OriginalColor_id144;
    bool HasTexture_id145;
};
cbuffer PerView 
{
    float4x4 View_id24;
    float4x4 ViewInverse_id25;
    float4x4 Projection_id26;
    float4x4 ProjectionInverse_id27;
    float4x4 ViewProjection_id28;
    float2 ProjScreenRay_id29;
    float4 Eye_id30;
};
cbuffer Globals 
{
    float2 Texture0TexelSize_id87;
    float2 Texture1TexelSize_id89;
    float2 Texture2TexelSize_id91;
    float2 Texture3TexelSize_id93;
    float2 Texture4TexelSize_id95;
    float2 Texture5TexelSize_id97;
    float2 Texture6TexelSize_id99;
    float2 Texture7TexelSize_id101;
    float2 Texture8TexelSize_id103;
    float2 Texture9TexelSize_id105;
};
Texture2D Texture0_id86;
Texture2D Texture1_id88;
Texture2D Texture2_id90;
Texture2D Texture3_id92;
Texture2D Texture4_id94;
Texture2D Texture5_id96;
Texture2D Texture6_id98;
Texture2D Texture7_id100;
Texture2D Texture8_id102;
Texture2D Texture9_id104;
TextureCube TextureCube0_id106;
TextureCube TextureCube1_id107;
TextureCube TextureCube2_id108;
TextureCube TextureCube3_id109;
Texture3D Texture3D0_id110;
Texture3D Texture3D1_id111;
Texture3D Texture3D2_id112;
Texture3D Texture3D3_id113;
SamplerState Sampler_id114;
SamplerState PointSampler_id115 
{
    Filter = MIN_MAG_MIP_POINT;
};
SamplerState LinearSampler_id116 
{
    Filter = MIN_MAG_MIP_LINEAR;
};
SamplerState LinearBorderSampler_id117 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Border;
    AddressV = Border;
};
SamplerComparisonState LinearClampCompareLessEqualSampler_id118 
{
    Filter = COMPARISON_MIN_MAG_LINEAR_MIP_POINT;
    AddressU = Clamp;
    AddressV = Clamp;
    ComparisonFunc = LessEqual;
};
SamplerState AnisotropicSampler_id119 
{
    Filter = ANISOTROPIC;
};
SamplerState AnisotropicRepeatSampler_id120 
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
    MaxAnisotropy = 16;
};
SamplerState PointRepeatSampler_id121 
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState LinearRepeatSampler_id122 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState RepeatSampler_id123 
{
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState Sampler0_id124;
SamplerState Sampler1_id125;
SamplerState Sampler2_id126;
SamplerState Sampler3_id127;
SamplerState Sampler4_id128;
SamplerState Sampler5_id129;
SamplerState Sampler6_id130;
SamplerState Sampler7_id131;
SamplerState Sampler8_id132;
SamplerState Sampler9_id133;
Texture2D OriginalTexture_id146;
void PrepareEnvironmentLight_id39(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id46 = 0;
    streams.envLightSpecularColor_id47 = 0;
}
void ResetStream_id54()
{
}
void AfterLightingAndShading_id70()
{
}
float3 ComputeEnvironmentLightContribution_id63(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id68;
    return diffuseColor * streams.envLightDiffuseColor_id46;
}
void PrepareEnvironmentLight_id59(inout PS_STREAMS streams)
{
    PrepareEnvironmentLight_id39(streams);
    streams.envLightDiffuseColor_id46 = 1;
    streams.envLightSpecularColor_id47 = 1;
}
void PrepareForLightingAndShading_id67()
{
}
void PrepareMaterialForLightingAndShading_id53(inout PS_STREAMS streams)
{
    streams.lightDirectAmbientOcclusion_id49 = lerp(1.0, streams.matAmbientOcclusion_id56, streams.matAmbientOcclusionDirectLightingFactor_id57);
    streams.matDiffuseVisible_id68 = streams.matDiffuse_id52.rgb * lerp(1.0f, streams.matCavity_id58, streams.matCavityDiffuse_id59) * streams.matDiffuseSpecularAlphaBlend_id64.r * streams.matAlphaBlendColor_id65;
    streams.matSpecularVisible_id70 = streams.matSpecular_id54.rgb * streams.matSpecularIntensity_id55 * lerp(1.0f, streams.matCavity_id58, streams.matCavitySpecular_id60) * streams.matDiffuseSpecularAlphaBlend_id64.g * streams.matAlphaBlendColor_id65;
    streams.NdotV_id71 = max(dot(streams.normalWS_id18, streams.viewWS_id67), 0.0001f);
    float roughness = 1.0f - streams.matGlossiness_id53;
    streams.alphaRoughness_id69 = max(roughness * roughness, 0.001);
}
void ResetLightStream_id52(inout PS_STREAMS streams)
{
    streams.lightPositionWS_id40 = 0;
    streams.lightDirectionWS_id41 = 0;
    streams.lightColor_id42 = 0;
    streams.lightColorNdotL_id43 = 0;
    streams.lightSpecularColorNdotL_id44 = 0;
    streams.lightAttenuation_id45 = 1.0f;
    streams.envLightDiffuseColor_id46 = 0;
    streams.envLightSpecularColor_id47 = 0;
    streams.lightDirectAmbientOcclusion_id49 = 1.0f;
    streams.NdotL_id48 = 0;
}
void UpdateNormalFromTangentSpace_id21(float3 normalInTangentSpace)
{
}
float4 Compute_id60(inout PS_STREAMS streams)
{
    float factor = sin(Time_id84 * 6.0f) * 0.25f + 0.25f;
    float4 color = HasTexture_id145 ? OriginalTexture_id146.Sample(LinearSampler_id116, streams.TexCoord_id134) : OriginalColor_id144;
    float4 reloadColor = float4(0.25f, 1.0f, 0.25f, 1.0f);
    return lerp(color, reloadColor, factor);
}
void ResetStream_id55(inout PS_STREAMS streams)
{
    ResetStream_id54();
    streams.matBlend_id39 = 0.0f;
}
void Compute_id104(inout PS_STREAMS streams)
{
    UpdateNormalFromTangentSpace_id21(streams.matNormal_id50);
    if (!streams.IsFrontFace_id1)
        streams.normalWS_id18 = -streams.normalWS_id18;
    ResetLightStream_id52(streams);
    PrepareMaterialForLightingAndShading_id53(streams);

    {
        PrepareForLightingAndShading_id67();
    }
    float3 directLightingContribution = 0;
    float3 environmentLightingContribution = 0;

    {
        PrepareEnvironmentLight_id59(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id63(streams);
        }
    }
    streams.shadingColor_id72 += directLightingContribution * PI_id149 + environmentLightingContribution;
    streams.shadingColorAlpha_id73 = streams.matDiffuse_id52.a;

    {
        AfterLightingAndShading_id70();
    }
}
void Compute_id88(inout PS_STREAMS streams)
{
    float4 colorBase = Compute_id60(streams);
    streams.matDiffuse_id52 = colorBase;
    streams.matColorBase_id51 = colorBase;
}
void ResetStream_id56(inout PS_STREAMS streams)
{
    ResetStream_id55(streams);
    streams.matNormal_id50 = float3(0, 0, 1);
    streams.matColorBase_id51 = 0.0f;
    streams.matDiffuse_id52 = 0.0f;
    streams.matDiffuseVisible_id68 = 0.0f;
    streams.matSpecular_id54 = 0.0f;
    streams.matSpecularVisible_id70 = 0.0f;
    streams.matSpecularIntensity_id55 = 1.0f;
    streams.matGlossiness_id53 = 0.0f;
    streams.alphaRoughness_id69 = 1.0f;
    streams.matAmbientOcclusion_id56 = 1.0f;
    streams.matAmbientOcclusionDirectLightingFactor_id57 = 0.0f;
    streams.matCavity_id58 = 1.0f;
    streams.matCavityDiffuse_id59 = 0.0f;
    streams.matCavitySpecular_id60 = 0.0f;
    streams.matEmissive_id61 = 0.0f;
    streams.matEmissiveIntensity_id62 = 0.0f;
    streams.matScatteringStrength_id63 = 1.0f;
    streams.matDiffuseSpecularAlphaBlend_id64 = 1.0f;
    streams.matAlphaBlendColor_id65 = 1.0f;
    streams.matAlphaDiscard_id66 = 0.1f;
}
float4 ComputeShadingPosition_id11(float4 world)
{
    return mul(world, ViewProjection_id28);
}
void PostTransformPosition_id6()
{
}
void PreTransformPosition_id4()
{
}
void Compute_id38(inout PS_STREAMS streams)
{

    {
        Compute_id88(streams);
    }

    {
        Compute_id104(streams);
    }
}
void ResetStream_id37(inout PS_STREAMS streams)
{
    ResetStream_id56(streams);
    streams.shadingColorAlpha_id73 = 1.0f;
}
void PostTransformPosition_id12(inout VS_STREAMS streams)
{
    PostTransformPosition_id6();
    streams.ShadingPosition_id0 = ComputeShadingPosition_id11(streams.PositionWS_id21);
    streams.PositionH_id23 = streams.ShadingPosition_id0;
    streams.DepthVS_id22 = streams.ShadingPosition_id0.w;
}
void TransformPosition_id5()
{
}
void PreTransformPosition_id10(inout VS_STREAMS streams)
{
    PreTransformPosition_id4();
    streams.PositionWS_id21 = mul(streams.Position_id20, World_id31);
}
float4 Shading_id29(inout PS_STREAMS streams)
{
    streams.viewWS_id67 = normalize(Eye_id30.xyz - streams.PositionWS_id21.xyz);
    streams.shadingColor_id72 = 0;
    ResetStream_id37(streams);
    Compute_id38(streams);
    return float4(streams.shadingColor_id72, streams.shadingColorAlpha_id73);
}
void PSMain_id1()
{
}
void BaseTransformVS_id8(inout VS_STREAMS streams)
{
    PreTransformPosition_id10(streams);
    TransformPosition_id5();
    PostTransformPosition_id12(streams);
}
void VSMain_id0()
{
}
void PSMain_id3(inout PS_STREAMS streams)
{
    PSMain_id1();
    streams.ColorTarget_id2 = Shading_id29(streams);
}
void GenerateNormal_PS_id20(inout PS_STREAMS streams)
{
    if (dot(streams.normalWS_id18, streams.normalWS_id18) > 0)
        streams.normalWS_id18 = normalize(streams.normalWS_id18);
    streams.meshNormalWS_id16 = streams.normalWS_id18;
}
void GenerateNormal_VS_id19(inout VS_STREAMS streams)
{
    streams.meshNormalWS_id16 = mul(streams.meshNormal_id15, (float3x3)WorldInverseTranspose_id33);
    streams.normalWS_id18 = streams.meshNormalWS_id16;
}
void VSMain_id9(inout VS_STREAMS streams)
{
    VSMain_id0();
    BaseTransformVS_id8(streams);
}
PS_OUTPUT PSMain(PS_INPUT __input__)
{
    PS_STREAMS streams = (PS_STREAMS)0;
    streams.PositionWS_id21 = __input__.PositionWS_id21;
    streams.normalWS_id18 = __input__.normalWS_id18;
    streams.TexCoord_id134 = __input__.TexCoord_id134;
    streams.IsFrontFace_id1 = __input__.IsFrontFace_id1;
    GenerateNormal_PS_id20(streams);
    PSMain_id3(streams);
    PS_OUTPUT __output__ = (PS_OUTPUT)0;
    __output__.ColorTarget_id2 = streams.ColorTarget_id2;
    return __output__;
}
VS_OUTPUT VSMain(VS_INPUT __input__)
{
    VS_STREAMS streams = (VS_STREAMS)0;
    streams.Position_id20 = __input__.Position_id20;
    streams.meshNormal_id15 = __input__.meshNormal_id15;
    streams.TexCoord_id134 = __input__.TexCoord_id134;
    VSMain_id9(streams);
    GenerateNormal_VS_id19(streams);
    VS_OUTPUT __output__ = (VS_OUTPUT)0;
    __output__.PositionWS_id21 = streams.PositionWS_id21;
    __output__.ShadingPosition_id0 = streams.ShadingPosition_id0;
    __output__.normalWS_id18 = streams.normalWS_id18;
    __output__.TexCoord_id134 = streams.TexCoord_id134;
    return __output__;
}
