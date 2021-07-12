/**************************
***** Compiler Parameters *****
***************************
@P EffectName: StrideForwardShadingEffect.ShadowMapCaster
@P   - Material.PixelStageSurfaceShaders: mixin MaterialSurfaceArray [{layers = [mixin MaterialSurfaceDiffuse [{diffuseMap = ComputeColorConstantColorLink<Material.DiffuseValue>}], mixin MaterialSurfaceLightingAndShading [{surfaces = [MaterialSurfaceShadingDiffuseLambert<false>]}]]}]
@P Material.PixelStageStreamInitializer: mixin MaterialStream, MaterialPixelShadingStream
@P Lighting.DirectLightGroups: mixin LightDirectionalGroup<8>, mixin LightDirectionalGroup<1>, ShadowMapReceiverDirectional<4,1,true,true,false,false>, ShadowMapFilterDefault<PerView.Lighting>, LightClusteredPointGroup, LightClusteredSpotGroup
@P Lighting.EnvironmentLights: LightSimpleAmbient, EnvironmentLight
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
cbuffer PerView [Size: 1696]
@C    View_id24 => Transformation.View
@C    ViewInverse_id25 => Transformation.ViewInverse
@C    Projection_id26 => Transformation.Projection
@C    ProjectionInverse_id27 => Transformation.ProjectionInverse
@C    ViewProjection_id28 => Transformation.ViewProjection
@C    ProjScreenRay_id29 => Transformation.ProjScreenRay
@C    Eye_id30 => Transformation.Eye
@C    NearClipPlane_id168 => Camera.NearClipPlane
@C    FarClipPlane_id169 => Camera.FarClipPlane
@C    ZProjection_id170 => Camera.ZProjection
@C    ViewSize_id171 => Camera.ViewSize
@C    AspectRatio_id172 => Camera.AspectRatio
@C    _padding_PerView_Default => _padding_PerView_Default
@C    LightCount_id84 => DirectLightGroupPerView.LightCount.directLightGroups[0]
@C    Lights_id86 => LightDirectionalGroup.Lights.directLightGroups[0]
@C    LightCount_id87 => DirectLightGroupPerView.LightCount.directLightGroups[1]
@C    Lights_id89 => LightDirectionalGroup.Lights.directLightGroups[1]
@C    ShadowMapTextureSize_id91 => ShadowMap.TextureSize.directLightGroups[1]
@C    ShadowMapTextureTexelSize_id92 => ShadowMap.TextureTexelSize.directLightGroups[1]
@C    WorldToShadowCascadeUV_id154 => ShadowMapReceiverBase.WorldToShadowCascadeUV.directLightGroups[1]
@C    InverseWorldToShadowCascadeUV_id155 => ShadowMapReceiverBase.InverseWorldToShadowCascadeUV.directLightGroups[1]
@C    ViewMatrices_id156 => ShadowMapReceiverBase.ViewMatrices.directLightGroups[1]
@C    DepthRanges_id157 => ShadowMapReceiverBase.DepthRanges.directLightGroups[1]
@C    DepthBiases_id158 => ShadowMapReceiverBase.DepthBiases.directLightGroups[1]
@C    OffsetScales_id159 => ShadowMapReceiverBase.OffsetScales.directLightGroups[1]
@C    CascadeDepthSplits_id166 => ShadowMapReceiverDirectional.CascadeDepthSplits.directLightGroups[1]
@C    ClusterDepthScale_id177 => LightClustered.ClusterDepthScale
@C    ClusterDepthBias_id178 => LightClustered.ClusterDepthBias
@C    ClusterStride_id179 => LightClustered.ClusterStride
@C    AmbientLight_id182 => LightSimpleAmbient.AmbientLight.environmentLights[0]
@C    _padding_PerView_Lighting => _padding_PerView_Lighting
***************************
******  Resources    ******
***************************
@R    ShadowMapTexture_id90 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id90 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    LightClusters_id175 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightClusters_id175 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightIndices_id176 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    LightIndices_id176 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    PointLights_id180 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    PointLights_id180 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id181 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id181 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    PerDraw => PerDraw [Stage: Vertex, Slot: (0-0)]
@R    PerView => PerView [Stage: Vertex, Slot: (1-1)]
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
@S    ShadowMapCasterNoPixelShader => cc7142412cfd324e26085f940beb9f1d
@S    LightDirectionalGroup => ac53667662784343d421b00fac059f9a
@S    DirectLightGroupPerView => 8e17a5b08d2245289bb7a2dfb37a8dd8
@S    LightDirectional => a342c290a036eb9fbb9d93bdd7fa32de
@S    ShadowMapReceiverDirectional => 0bf9ec91d0d63d48d1ba26668b1f66ec
@S    ShadowMapReceiverBase => 378009624fef0fa663eadb2f18a1e67c
@S    ShadowMapGroup => 7cc147d3462fc743e45887d78f3ee6c4
@S    ShadowMapCommon => a636008e844a6b4cc640e0310830794e
@S    ShadowMapFilterBase => 92c4ea2f9b3a7a114f7d9d7556b97ea5
@S    Texturing => 6605f68230266eff2bc8b4e8102ede6b
@S    Math => 395aa210901b9e0783594d1b4fb0a441
@S    ShadowMapFilterDefault => 9c45e5253e19bb8099c26ac84bf398f3
@S    LightClusteredPointGroup => daa4f884feed02bad152ef53f5820771
@S    LightClustered => f939f2ab47789c1fd022283bcadfa42e
@S    ScreenPositionBase => 447b80ee2709564be56e617346288f78
@S    Camera => 68de88612bfb3b0a92e9082b82b993a9
@S    LightPoint => ffca22202bf34deee191bc36e95d9ccf
@S    LightUtil => 21256a4364432cc656447ee541333792
@S    LightClusteredSpotGroup => ae51eef97b7a5ad4cf63e15461308bdd
@S    LightSpot => ffc8735093683cafbdbc1f59643b9b8f
@S    SpotLightDataInternalShader => 5f0bd728a1c56b1def3b26d3859f6876
@S    LightSpotAttenuationDefault => 3764b4b242d09ba41b1a9cd5678ddf55
@S    LightSimpleAmbient => 6b7c24748a4d72e5eb22ae12802d3b2d
@S    MaterialSurfaceArray => 6c056e27887290fe2f9862991714228f
@S    MaterialSurfaceDiffuse => 4130aff8a17174b1b1457299185be45e
@S    IMaterialSurfacePixel => efa5da7adb861031599778e9829daca8
@S    ComputeColorConstantColorLink => 66070b757702cedd6874020f33fef9bf
@S    MaterialSurfaceLightingAndShading => 56a8877cd2af395727b11f69c761ad41
@S    IMaterialSurfaceShading => 86261e2a0ca0229f0d6ddf87490e5967
@S    MaterialSurfaceShadingDiffuseLambert => 9adb7783d6ea173f9f8ffdfa5c141256
***************************
*****     Stages      *****
***************************
@G    Vertex => 17adedc7b221d85f10ab072c2b3c7a15
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
//   float NearClipPlane_id168;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id169;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id170;          // Offset:  360 Size:     8 [unused]
//   float2 ViewSize_id171;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id172;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id84;               // Offset:  400 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id86[8];                  // Offset:  416 Size:   252 [unused]
//   int LightCount_id87;               // Offset:  668 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  672
//       float3 Color;                  // Offset:  688
//
//   } Lights_id89;                     // Offset:  672 Size:    28 [unused]
//   float2 ShadowMapTextureSize_id91;  // Offset:  704 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id92;// Offset:  712 Size:     8 [unused]
//   float4x4 WorldToShadowCascadeUV_id154[4];// Offset:  720 Size:   256 [unused]
//   float4x4 InverseWorldToShadowCascadeUV_id155[4];// Offset:  976 Size:   256 [unused]
//   float4x4 ViewMatrices_id156[4];    // Offset: 1232 Size:   256 [unused]
//   float2 DepthRanges_id157[4];       // Offset: 1488 Size:    56 [unused]
//   float DepthBiases_id158;           // Offset: 1552 Size:     4 [unused]
//   float OffsetScales_id159;          // Offset: 1568 Size:     4 [unused]
//   float CascadeDepthSplits_id166[4]; // Offset: 1584 Size:    52 [unused]
//   float ClusterDepthScale_id177;     // Offset: 1636 Size:     4 [unused]
//   float ClusterDepthBias_id178;      // Offset: 1640 Size:     4 [unused]
//   float2 ClusterStride_id179;        // Offset: 1648 Size:     8 [unused]
//   float3 AmbientLight_id182;         // Offset: 1664 Size:    12 [unused]
//   float4 _padding_PerView_Lighting;  // Offset: 1680 Size:    16 [unused]
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
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION_WS              0   xyzw        0     NONE   float   xyzw
// SV_Position              0   xyzw        1      POS   float   xyzw
// POSITIONH                0   xyzw        2     NONE   float   xyzw
// DEPTH_VS                 0   x           3     NONE   float   x   
// MESHNORMALWS_ID16_SEM     0    yzw        3     NONE   float    yzw
// NORMALWS                 0   xyz         4     NONE   float   xyz 
// SCREENPOSITION_ID167_SEM     0   xyzw        5     NONE   float   xyzw
//
vs_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[11], immediateIndexed
dcl_constantbuffer CB1[20], immediateIndexed
dcl_input v0.xyzw
dcl_input v1.xyz
dcl_output o0.xyzw
dcl_output_siv o1.xyzw, position
dcl_output o2.xyzw
dcl_output o3.x
dcl_output o3.yzw
dcl_output o4.xyz
dcl_output o5.xyzw
dcl_temps 2
//
// Initial variable locations:
//   v0.x <- __input__.Position_id20.x; v0.y <- __input__.Position_id20.y; v0.z <- __input__.Position_id20.z; v0.w <- __input__.Position_id20.w; 
//   v1.x <- __input__.meshNormal_id15.x; v1.y <- __input__.meshNormal_id15.y; v1.z <- __input__.meshNormal_id15.z; 
//   o5.x <- <VSMain return value>.ScreenPosition_id167.x; o5.y <- <VSMain return value>.ScreenPosition_id167.y; o5.z <- <VSMain return value>.ScreenPosition_id167.z; o5.w <- <VSMain return value>.ScreenPosition_id167.w; 
//   o4.x <- <VSMain return value>.normalWS_id18.x; o4.y <- <VSMain return value>.normalWS_id18.y; o4.z <- <VSMain return value>.normalWS_id18.z; 
//   o3.x <- <VSMain return value>.DepthVS_id22; o3.y <- <VSMain return value>.meshNormalWS_id16.x; o3.z <- <VSMain return value>.meshNormalWS_id16.y; o3.w <- <VSMain return value>.meshNormalWS_id16.z; 
//   o2.x <- <VSMain return value>.PositionH_id23.x; o2.y <- <VSMain return value>.PositionH_id23.y; o2.z <- <VSMain return value>.PositionH_id23.z; o2.w <- <VSMain return value>.PositionH_id23.w; 
//   o1.x <- <VSMain return value>.ShadingPosition_id0.x; o1.y <- <VSMain return value>.ShadingPosition_id0.y; o1.z <- <VSMain return value>.ShadingPosition_id0.z; o1.w <- <VSMain return value>.ShadingPosition_id0.w; 
//   o0.x <- <VSMain return value>.PositionWS_id21.x; o0.y <- <VSMain return value>.PositionWS_id21.y; o0.z <- <VSMain return value>.PositionWS_id21.z; o0.w <- <VSMain return value>.PositionWS_id21.w
//
#line 233 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_ShadowMapCaster_d78fb301c8f7cbc2e9ad8b9821170924.hlsl"
dp4 r0.x, v0.xyzw, cb0[0].xyzw  // r0.x <- streams.PositionWS_id21.x
dp4 r0.y, v0.xyzw, cb0[1].xyzw  // r0.y <- streams.PositionWS_id21.y
dp4 r0.z, v0.xyzw, cb0[2].xyzw  // r0.z <- streams.PositionWS_id21.z
dp4 r0.w, v0.xyzw, cb0[3].xyzw  // r0.w <- streams.PositionWS_id21.w

#line 274
mov o0.xyzw, r0.xyzw

#line 212
dp4 r1.x, r0.xyzw, cb1[16].xyzw  // r1.x <- <ComputeShadingPosition_id11 return value>.x
dp4 r1.y, r0.xyzw, cb1[17].xyzw  // r1.y <- <ComputeShadingPosition_id11 return value>.y
dp4 r1.z, r0.xyzw, cb1[18].xyzw  // r1.z <- <ComputeShadingPosition_id11 return value>.z
dp4 r1.w, r0.xyzw, cb1[19].xyzw  // r1.w <- <ComputeShadingPosition_id11 return value>.w

#line 274
mov o1.xyzw, r1.xyzw
mov o2.xyzw, r1.xyzw
mov o5.xyzw, r1.xyzw
mov o3.x, r1.w

#line 246
dp3 r0.y, v1.xyzx, cb0[8].xyzx  // r0.y <- streams.meshNormalWS_id16.x
dp3 r0.z, v1.xyzx, cb0[9].xyzx  // r0.z <- streams.meshNormalWS_id16.y
dp3 r0.w, v1.xyzx, cb0[10].xyzx  // r0.w <- streams.meshNormalWS_id16.z

#line 274
mov o3.yzw, r0.yyzw
mov o4.xyz, r0.yzwy
ret 
// Approximately 19 instruction slots used
***************************
*************************/
const static int TMaxLightCount_id85 = 8;
const static int TMaxLightCount_id88 = 1;
const static int TCascadeCountBase_id152 = 4;
const static int TLightCountBase_id153 = 1;
const static int TCascadeCount_id160 = 4;
const static int TLightCount_id161 = 1;
struct VS_STREAMS 
{
    float4 Position_id20;
    float3 meshNormal_id15;
    float4 PositionWS_id21;
    float4 ShadingPosition_id0;
    float4 PositionH_id23;
    float DepthVS_id22;
    float3 meshNormalWS_id16;
    float3 normalWS_id18;
    float4 ScreenPosition_id167;
};
struct VS_OUTPUT 
{
    float4 PositionWS_id21 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float4 PositionH_id23 : POSITIONH;
    float DepthVS_id22 : DEPTH_VS;
    float3 meshNormalWS_id16 : MESHNORMALWS_ID16_SEM;
    float3 normalWS_id18 : NORMALWS;
    float4 ScreenPosition_id167 : SCREENPOSITION_ID167_SEM;
};
struct VS_INPUT 
{
    float4 Position_id20 : POSITION;
    float3 meshNormal_id15 : NORMAL;
};
struct DirectionalLightData 
{
    float3 DirectionWS;
    float3 Color;
};
struct PointLightData 
{
    float3 PositionWS;
    float InvSquareRadius;
    float3 Color;
};
struct PointLightDataInternal 
{
    float3 PositionWS;
    float InvSquareRadius;
    float3 Color;
};
struct SpotLightDataInternal 
{
    float3 PositionWS;
    float3 DirectionWS;
    float3 AngleOffsetAndInvSquareRadius;
    float3 Color;
};
struct SpotLightData 
{
    float3 PositionWS;
    float3 DirectionWS;
    float3 AngleOffsetAndInvSquareRadius;
    float3 Color;
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
cbuffer PerMaterial 
{
    float4 constantColor_id183;
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
    float NearClipPlane_id168 = 1.0f;
    float FarClipPlane_id169 = 100.0f;
    float2 ZProjection_id170;
    float2 ViewSize_id171;
    float AspectRatio_id172;
    float4 _padding_PerView_Default;
    int LightCount_id84;
    DirectionalLightData Lights_id86[TMaxLightCount_id85];
    int LightCount_id87;
    DirectionalLightData Lights_id89[TMaxLightCount_id88];
    float2 ShadowMapTextureSize_id91;
    float2 ShadowMapTextureTexelSize_id92;
    float4x4 WorldToShadowCascadeUV_id154[TCascadeCountBase_id152 * TLightCountBase_id153];
    float4x4 InverseWorldToShadowCascadeUV_id155[TCascadeCountBase_id152 * TLightCountBase_id153];
    float4x4 ViewMatrices_id156[TCascadeCountBase_id152 * TLightCountBase_id153];
    float2 DepthRanges_id157[TCascadeCountBase_id152 * TLightCountBase_id153];
    float DepthBiases_id158[TLightCountBase_id153];
    float OffsetScales_id159[TLightCountBase_id153];
    float CascadeDepthSplits_id166[TCascadeCount_id160 * TLightCount_id161];
    float ClusterDepthScale_id177;
    float ClusterDepthBias_id178;
    float2 ClusterStride_id179;
    float3 AmbientLight_id182;
    float4 _padding_PerView_Lighting;
};
cbuffer Globals 
{
    float2 Texture0TexelSize_id94;
    float2 Texture1TexelSize_id96;
    float2 Texture2TexelSize_id98;
    float2 Texture3TexelSize_id100;
    float2 Texture4TexelSize_id102;
    float2 Texture5TexelSize_id104;
    float2 Texture6TexelSize_id106;
    float2 Texture7TexelSize_id108;
    float2 Texture8TexelSize_id110;
    float2 Texture9TexelSize_id112;
};
Texture2D Texture0_id93;
Texture2D Texture1_id95;
Texture2D Texture2_id97;
Texture2D Texture3_id99;
Texture2D Texture4_id101;
Texture2D Texture5_id103;
Texture2D Texture6_id105;
Texture2D Texture7_id107;
Texture2D Texture8_id109;
Texture2D Texture9_id111;
TextureCube TextureCube0_id113;
TextureCube TextureCube1_id114;
TextureCube TextureCube2_id115;
TextureCube TextureCube3_id116;
Texture3D Texture3D0_id117;
Texture3D Texture3D1_id118;
Texture3D Texture3D2_id119;
Texture3D Texture3D3_id120;
SamplerState Sampler_id121;
SamplerState PointSampler_id122 
{
    Filter = MIN_MAG_MIP_POINT;
};
SamplerState LinearSampler_id123 
{
    Filter = MIN_MAG_MIP_LINEAR;
};
SamplerState LinearBorderSampler_id124 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Border;
    AddressV = Border;
};
SamplerComparisonState LinearClampCompareLessEqualSampler_id125 
{
    Filter = COMPARISON_MIN_MAG_LINEAR_MIP_POINT;
    AddressU = Clamp;
    AddressV = Clamp;
    ComparisonFunc = LessEqual;
};
SamplerState AnisotropicSampler_id126 
{
    Filter = ANISOTROPIC;
};
SamplerState AnisotropicRepeatSampler_id127 
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
    MaxAnisotropy = 16;
};
SamplerState PointRepeatSampler_id128 
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState LinearRepeatSampler_id129 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState RepeatSampler_id130 
{
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState Sampler0_id131;
SamplerState Sampler1_id132;
SamplerState Sampler2_id133;
SamplerState Sampler3_id134;
SamplerState Sampler4_id135;
SamplerState Sampler5_id136;
SamplerState Sampler6_id137;
SamplerState Sampler7_id138;
SamplerState Sampler8_id139;
SamplerState Sampler9_id140;
Texture2D ShadowMapTexture_id90;
Texture3D<uint2> LightClusters_id175;
Buffer<uint> LightIndices_id176;
Buffer<float4> PointLights_id180;
Buffer<float4> SpotLights_id181;
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
void BaseTransformVS_id8(inout VS_STREAMS streams)
{
    PreTransformPosition_id10(streams);
    TransformPosition_id5();
    PostTransformPosition_id12(streams);
}
void VSMain_id0()
{
}
void GenerateNormal_VS_id21(inout VS_STREAMS streams)
{
    streams.meshNormalWS_id16 = mul(streams.meshNormal_id15, (float3x3)WorldInverseTranspose_id33);
    streams.normalWS_id18 = streams.meshNormalWS_id16;
}
void VSMain_id9(inout VS_STREAMS streams)
{
    VSMain_id0();
    BaseTransformVS_id8(streams);
}
void VSMain_id19(inout VS_STREAMS streams)
{
    VSMain_id9(streams);
    GenerateNormal_VS_id21(streams);
}
VS_OUTPUT VSMain(VS_INPUT __input__)
{
    VS_STREAMS streams = (VS_STREAMS)0;
    streams.Position_id20 = __input__.Position_id20;
    streams.meshNormal_id15 = __input__.meshNormal_id15;
    VSMain_id19(streams);
    streams.ScreenPosition_id167 = streams.ShadingPosition_id0;
    VS_OUTPUT __output__ = (VS_OUTPUT)0;
    __output__.PositionWS_id21 = streams.PositionWS_id21;
    __output__.ShadingPosition_id0 = streams.ShadingPosition_id0;
    __output__.PositionH_id23 = streams.PositionH_id23;
    __output__.DepthVS_id22 = streams.DepthVS_id22;
    __output__.meshNormalWS_id16 = streams.meshNormalWS_id16;
    __output__.normalWS_id18 = streams.normalWS_id18;
    __output__.ScreenPosition_id167 = streams.ScreenPosition_id167;
    return __output__;
}
