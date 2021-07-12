/**************************
***** Compiler Parameters *****
***************************
@P EffectName: StrideForwardShadingEffect
@P   - Material.PixelStageSurfaceShaders: mixin MaterialSurfaceArray [{layers = [mixin MaterialSurfaceDiffuse [{diffuseMap = ComputeColorConstantColorLink<Material.DiffuseValue>}], mixin MaterialSurfaceLightingAndShading [{surfaces = [MaterialSurfaceShadingDiffuseLambert<false>]}]]}]
@P Material.PixelStageStreamInitializer: mixin MaterialStream, MaterialPixelShadingStream
@P Lighting.DirectLightGroups: mixin LightDirectionalGroup<8>, mixin LightDirectionalGroup<1>, ShadowMapReceiverDirectional<4,1,true,true,false,false>, ShadowMapFilterPcf<PerView.Lighting,5>, LightClusteredPointGroup, LightClusteredSpotGroup
@P Lighting.EnvironmentLights: LightSimpleAmbient, EnvironmentLight
@P StrideEffectBase.RenderTargetExtensions: mixin [{ShadingColor1 = GBufferOutputSubsurfaceScatteringMaterialIndex}]
***************************
****  ConstantBuffers  ****
***************************
cbuffer PerDraw [Size: 432]
@C    World_id32 => Transformation.World
@C    WorldInverse_id33 => Transformation.WorldInverse
@C    WorldInverseTranspose_id34 => Transformation.WorldInverseTranspose
@C    WorldView_id35 => Transformation.WorldView
@C    WorldViewInverse_id36 => Transformation.WorldViewInverse
@C    WorldViewProjection_id37 => Transformation.WorldViewProjection
@C    WorldScale_id38 => Transformation.WorldScale
@C    EyeMS_id39 => Transformation.EyeMS
@C    MaterialIndex_id83 => GBufferOutputSubsurfaceScatteringMaterialIndex.MaterialIndex
cbuffer PerMaterial [Size: 16]
@C    constantColor_id186 => Material.DiffuseValue
cbuffer PerView [Size: 1696]
@C    View_id25 => Transformation.View
@C    ViewInverse_id26 => Transformation.ViewInverse
@C    Projection_id27 => Transformation.Projection
@C    ProjectionInverse_id28 => Transformation.ProjectionInverse
@C    ViewProjection_id29 => Transformation.ViewProjection
@C    ProjScreenRay_id30 => Transformation.ProjScreenRay
@C    Eye_id31 => Transformation.Eye
@C    NearClipPlane_id171 => Camera.NearClipPlane
@C    FarClipPlane_id172 => Camera.FarClipPlane
@C    ZProjection_id173 => Camera.ZProjection
@C    ViewSize_id174 => Camera.ViewSize
@C    AspectRatio_id175 => Camera.AspectRatio
@C    _padding_PerView_Default => _padding_PerView_Default
@C    LightCount_id86 => DirectLightGroupPerView.LightCount.directLightGroups[0]
@C    Lights_id88 => LightDirectionalGroup.Lights.directLightGroups[0]
@C    LightCount_id89 => DirectLightGroupPerView.LightCount.directLightGroups[1]
@C    Lights_id91 => LightDirectionalGroup.Lights.directLightGroups[1]
@C    ShadowMapTextureSize_id93 => ShadowMap.TextureSize.directLightGroups[1]
@C    ShadowMapTextureTexelSize_id94 => ShadowMap.TextureTexelSize.directLightGroups[1]
@C    WorldToShadowCascadeUV_id156 => ShadowMapReceiverBase.WorldToShadowCascadeUV.directLightGroups[1]
@C    InverseWorldToShadowCascadeUV_id157 => ShadowMapReceiverBase.InverseWorldToShadowCascadeUV.directLightGroups[1]
@C    ViewMatrices_id158 => ShadowMapReceiverBase.ViewMatrices.directLightGroups[1]
@C    DepthRanges_id159 => ShadowMapReceiverBase.DepthRanges.directLightGroups[1]
@C    DepthBiases_id160 => ShadowMapReceiverBase.DepthBiases.directLightGroups[1]
@C    OffsetScales_id161 => ShadowMapReceiverBase.OffsetScales.directLightGroups[1]
@C    CascadeDepthSplits_id168 => ShadowMapReceiverDirectional.CascadeDepthSplits.directLightGroups[1]
@C    ClusterDepthScale_id180 => LightClustered.ClusterDepthScale
@C    ClusterDepthBias_id181 => LightClustered.ClusterDepthBias
@C    ClusterStride_id182 => LightClustered.ClusterStride
@C    AmbientLight_id185 => LightSimpleAmbient.AmbientLight.environmentLights[0]
@C    _padding_PerView_Lighting => _padding_PerView_Lighting
***************************
******  Resources    ******
***************************
@R    PerMaterial => PerMaterial [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id92 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id92 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    LightClusters_id178 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightClusters_id178 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightIndices_id179 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    LightIndices_id179 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    PointLights_id183 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    PointLights_id183 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id184 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id184 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    PerDraw => PerDraw [Stage: Vertex, Slot: (0-0)]
@R    PerView => PerView [Stage: Vertex, Slot: (1-1)]
@R    LinearClampCompareLessEqualSampler_id127 => Texturing.LinearClampCompareLessEqualSampler [Stage: Pixel, Slot: (0-0)]
@R    ShadowMapTexture_id92 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: Pixel, Slot: (0-0)]
@R    LightClusters_id178 => LightClustered.LightClusters [Stage: Pixel, Slot: (1-1)]
@R    LightIndices_id179 => LightClustered.LightIndices [Stage: Pixel, Slot: (2-2)]
@R    PointLights_id183 => LightClusteredPointGroup.PointLights [Stage: Pixel, Slot: (3-3)]
@R    SpotLights_id184 => LightClusteredSpotGroup.SpotLights [Stage: Pixel, Slot: (4-4)]
@R    PerDraw => PerDraw [Stage: Pixel, Slot: (0-0)]
@R    PerMaterial => PerMaterial [Stage: Pixel, Slot: (1-1)]
@R    PerView => PerView [Stage: Pixel, Slot: (2-2)]
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
@S    ShadowMapFilterPcf => 101a5eea4b5aec04d9bbfd95eee01fbc
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
@S    GBufferOutputSubsurfaceScatteringMaterialIndex => 5df9471bf02401dc5db0de4bbd3d8abb
***************************
*****     Stages      *****
***************************
@G    Vertex => 11e347e5be9c876829c23355144218e5
//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer PerDraw
// {
//
//   float4x4 World_id32;               // Offset:    0 Size:    64
//   float4x4 WorldInverse_id33;        // Offset:   64 Size:    64 [unused]
//   float4x4 WorldInverseTranspose_id34;// Offset:  128 Size:    64
//   float4x4 WorldView_id35;           // Offset:  192 Size:    64 [unused]
//   float4x4 WorldViewInverse_id36;    // Offset:  256 Size:    64 [unused]
//   float4x4 WorldViewProjection_id37; // Offset:  320 Size:    64 [unused]
//   float3 WorldScale_id38;            // Offset:  384 Size:    12 [unused]
//   float4 EyeMS_id39;                 // Offset:  400 Size:    16 [unused]
//   uint MaterialIndex_id83;           // Offset:  416 Size:     4 [unused]
//
// }
//
// cbuffer PerView
// {
//
//   float4x4 View_id25;                // Offset:    0 Size:    64 [unused]
//   float4x4 ViewInverse_id26;         // Offset:   64 Size:    64 [unused]
//   float4x4 Projection_id27;          // Offset:  128 Size:    64 [unused]
//   float4x4 ProjectionInverse_id28;   // Offset:  192 Size:    64 [unused]
//   float4x4 ViewProjection_id29;      // Offset:  256 Size:    64
//   float2 ProjScreenRay_id30;         // Offset:  320 Size:     8 [unused]
//   float4 Eye_id31;                   // Offset:  336 Size:    16 [unused]
//   float NearClipPlane_id171;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id172;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id173;          // Offset:  360 Size:     8 [unused]
//   float2 ViewSize_id174;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id175;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[8];                  // Offset:  416 Size:   252 [unused]
//   int LightCount_id89;               // Offset:  668 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  672
//       float3 Color;                  // Offset:  688
//
//   } Lights_id91;                     // Offset:  672 Size:    28 [unused]
//   float2 ShadowMapTextureSize_id93;  // Offset:  704 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id94;// Offset:  712 Size:     8 [unused]
//   float4x4 WorldToShadowCascadeUV_id156[4];// Offset:  720 Size:   256 [unused]
//   float4x4 InverseWorldToShadowCascadeUV_id157[4];// Offset:  976 Size:   256 [unused]
//   float4x4 ViewMatrices_id158[4];    // Offset: 1232 Size:   256 [unused]
//   float2 DepthRanges_id159[4];       // Offset: 1488 Size:    56 [unused]
//   float DepthBiases_id160;           // Offset: 1552 Size:     4 [unused]
//   float OffsetScales_id161;          // Offset: 1568 Size:     4 [unused]
//   float CascadeDepthSplits_id168[4]; // Offset: 1584 Size:    52 [unused]
//   float ClusterDepthScale_id180;     // Offset: 1636 Size:     4 [unused]
//   float ClusterDepthBias_id181;      // Offset: 1640 Size:     4 [unused]
//   float2 ClusterStride_id182;        // Offset: 1648 Size:     8 [unused]
//   float3 AmbientLight_id185;         // Offset: 1664 Size:    12 [unused]
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
// DEPTH_VS                 0   x           2     NONE   float   x   
// NORMALWS                 0    yzw        2     NONE   float    yzw
// SCREENPOSITION_ID170_SEM     0   xyzw        3     NONE   float   xyzw
//
vs_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[11], immediateIndexed
dcl_constantbuffer CB1[20], immediateIndexed
dcl_input v0.xyzw
dcl_input v1.xyz
dcl_output o0.xyzw
dcl_output_siv o1.xyzw, position
dcl_output o2.x
dcl_output o2.yzw
dcl_output o3.xyzw
dcl_temps 2
//
// Initial variable locations:
//   v0.x <- __input__.Position_id21.x; v0.y <- __input__.Position_id21.y; v0.z <- __input__.Position_id21.z; v0.w <- __input__.Position_id21.w; 
//   v1.x <- __input__.meshNormal_id16.x; v1.y <- __input__.meshNormal_id16.y; v1.z <- __input__.meshNormal_id16.z; 
//   o3.x <- <VSMain return value>.ScreenPosition_id170.x; o3.y <- <VSMain return value>.ScreenPosition_id170.y; o3.z <- <VSMain return value>.ScreenPosition_id170.z; o3.w <- <VSMain return value>.ScreenPosition_id170.w; 
//   o2.x <- <VSMain return value>.DepthVS_id23; o2.y <- <VSMain return value>.normalWS_id19.x; o2.z <- <VSMain return value>.normalWS_id19.y; o2.w <- <VSMain return value>.normalWS_id19.z; 
//   o1.x <- <VSMain return value>.ShadingPosition_id0.x; o1.y <- <VSMain return value>.ShadingPosition_id0.y; o1.z <- <VSMain return value>.ShadingPosition_id0.z; o1.w <- <VSMain return value>.ShadingPosition_id0.w; 
//   o0.x <- <VSMain return value>.PositionWS_id22.x; o0.y <- <VSMain return value>.PositionWS_id22.y; o0.z <- <VSMain return value>.PositionWS_id22.z; o0.w <- <VSMain return value>.PositionWS_id22.w
//
#line 1035 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_9546d91ef4de061e1ba089cf6d102d2b.hlsl"
dp4 r0.x, v0.xyzw, cb0[0].xyzw  // r0.x <- streams.PositionWS_id22.x
dp4 r0.y, v0.xyzw, cb0[1].xyzw  // r0.y <- streams.PositionWS_id22.y
dp4 r0.z, v0.xyzw, cb0[2].xyzw  // r0.z <- streams.PositionWS_id22.z
dp4 r0.w, v0.xyzw, cb0[3].xyzw  // r0.w <- streams.PositionWS_id22.w

#line 1122
mov o0.xyzw, r0.xyzw

#line 998
dp4 r1.x, r0.xyzw, cb1[16].xyzw  // r1.x <- <ComputeShadingPosition_id11 return value>.x
dp4 r1.y, r0.xyzw, cb1[17].xyzw  // r1.y <- <ComputeShadingPosition_id11 return value>.y
dp4 r1.z, r0.xyzw, cb1[18].xyzw  // r1.z <- <ComputeShadingPosition_id11 return value>.z
dp4 r1.w, r0.xyzw, cb1[19].xyzw  // r1.w <- <ComputeShadingPosition_id11 return value>.w

#line 1122
mov o1.xyzw, r1.xyzw
mov o3.xyzw, r1.xyzw
mov o2.x, r1.w

#line 1075
dp3 o2.y, v1.xyzx, cb0[8].xyzx
dp3 o2.z, v1.xyzx, cb0[9].xyzx
dp3 o2.w, v1.xyzx, cb0[10].xyzx

#line 1122
ret 
// Approximately 16 instruction slots used
@G    Pixel => 009cd1c85939d2ce5b81ff83913aa730
//
// Generated by Microsoft (R) HLSL Shader Compiler 10.1
//
//
// Buffer Definitions: 
//
// cbuffer PerDraw
// {
//
//   float4x4 World_id32;               // Offset:    0 Size:    64 [unused]
//   float4x4 WorldInverse_id33;        // Offset:   64 Size:    64 [unused]
//   float4x4 WorldInverseTranspose_id34;// Offset:  128 Size:    64 [unused]
//   float4x4 WorldView_id35;           // Offset:  192 Size:    64 [unused]
//   float4x4 WorldViewInverse_id36;    // Offset:  256 Size:    64 [unused]
//   float4x4 WorldViewProjection_id37; // Offset:  320 Size:    64 [unused]
//   float3 WorldScale_id38;            // Offset:  384 Size:    12 [unused]
//   float4 EyeMS_id39;                 // Offset:  400 Size:    16 [unused]
//   uint MaterialIndex_id83;           // Offset:  416 Size:     4
//
// }
//
// cbuffer PerMaterial
// {
//
//   float4 constantColor_id186;        // Offset:    0 Size:    16
//
// }
//
// cbuffer PerView
// {
//
//   float4x4 View_id25;                // Offset:    0 Size:    64 [unused]
//   float4x4 ViewInverse_id26;         // Offset:   64 Size:    64 [unused]
//   float4x4 Projection_id27;          // Offset:  128 Size:    64 [unused]
//   float4x4 ProjectionInverse_id28;   // Offset:  192 Size:    64 [unused]
//   float4x4 ViewProjection_id29;      // Offset:  256 Size:    64 [unused]
//   float2 ProjScreenRay_id30;         // Offset:  320 Size:     8 [unused]
//   float4 Eye_id31;                   // Offset:  336 Size:    16 [unused]
//   float NearClipPlane_id171;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id172;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id173;          // Offset:  360 Size:     8
//   float2 ViewSize_id174;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id175;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[8];                  // Offset:  416 Size:   252
//   int LightCount_id89;               // Offset:  668 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  672
//       float3 Color;                  // Offset:  688
//
//   } Lights_id91;                     // Offset:  672 Size:    28
//   float2 ShadowMapTextureSize_id93;  // Offset:  704 Size:     8
//   float2 ShadowMapTextureTexelSize_id94;// Offset:  712 Size:     8
//   float4x4 WorldToShadowCascadeUV_id156[4];// Offset:  720 Size:   256
//   float4x4 InverseWorldToShadowCascadeUV_id157[4];// Offset:  976 Size:   256 [unused]
//   float4x4 ViewMatrices_id158[4];    // Offset: 1232 Size:   256 [unused]
//   float2 DepthRanges_id159[4];       // Offset: 1488 Size:    56 [unused]
//   float DepthBiases_id160;           // Offset: 1552 Size:     4
//   float OffsetScales_id161;          // Offset: 1568 Size:     4
//   float CascadeDepthSplits_id168[4]; // Offset: 1584 Size:    52
//   float ClusterDepthScale_id180;     // Offset: 1636 Size:     4
//   float ClusterDepthBias_id181;      // Offset: 1640 Size:     4
//   float2 ClusterStride_id182;        // Offset: 1648 Size:     8
//   float3 AmbientLight_id185;         // Offset: 1664 Size:    12
//   float4 _padding_PerView_Lighting;  // Offset: 1680 Size:    16 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// LinearClampCompareLessEqualSampler_id127  sampler_c      NA          NA             s0      1 
// ShadowMapTexture_id92             texture  float4          2d             t0      1 
// LightClusters_id178               texture   uint2          3d             t1      1 
// LightIndices_id179                texture    uint         buf             t2      1 
// PointLights_id183                 texture  float4         buf             t3      1 
// SpotLights_id184                  texture  float4         buf             t4      1 
// PerDraw                           cbuffer      NA          NA            cb0      1 
// PerMaterial                       cbuffer      NA          NA            cb1      1 
// PerView                           cbuffer      NA          NA            cb2      1 
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// POSITION_WS              0   xyzw        0     NONE   float   xyz 
// SV_Position              0   xyzw        1      POS   float     z 
// DEPTH_VS                 0   x           2     NONE   float   x   
// NORMALWS                 0    yzw        2     NONE   float    yzw
// SCREENPOSITION_ID170_SEM     0   xyzw        3     NONE   float   xy w
// SV_IsFrontFace           0   x           4    FFACE    uint   x   
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_Target                0   xyzw        0   TARGET   float   xyzw
// SV_Target                1   xyzw        1   TARGET   float   xyzw
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[27], immediateIndexed
dcl_constantbuffer CB1[1], immediateIndexed
dcl_constantbuffer CB2[105], dynamicIndexed
dcl_sampler s0, mode_comparison
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture3d (uint,uint,uint,uint) t1
dcl_resource_buffer (uint,uint,uint,uint) t2
dcl_resource_buffer (float,float,float,float) t3
dcl_resource_buffer (float,float,float,float) t4
dcl_input_ps linear v0.xyz
dcl_input_ps_siv linear noperspective v1.z, position
dcl_input_ps linear v2.x
dcl_input_ps linear v2.yzw
dcl_input_ps linear v3.xyw
dcl_input_ps_sgv constant v4.x, is_front_face
dcl_output o0.xyzw
dcl_output o1.xyzw
dcl_temps 12
//
// Initial variable locations:
//   v0.x <- __input__.PositionWS_id22.x; v0.y <- __input__.PositionWS_id22.y; v0.z <- __input__.PositionWS_id22.z; v0.w <- __input__.PositionWS_id22.w; 
//   v1.x <- __input__.ShadingPosition_id0.x; v1.y <- __input__.ShadingPosition_id0.y; v1.z <- __input__.ShadingPosition_id0.z; v1.w <- __input__.ShadingPosition_id0.w; 
//   v2.x <- __input__.DepthVS_id23; v2.y <- __input__.normalWS_id19.x; v2.z <- __input__.normalWS_id19.y; v2.w <- __input__.normalWS_id19.z; 
//   v3.x <- __input__.ScreenPosition_id170.x; v3.y <- __input__.ScreenPosition_id170.y; v3.z <- __input__.ScreenPosition_id170.z; v3.w <- __input__.ScreenPosition_id170.w; 
//   v4.x <- __input__.IsFrontFace_id1; 
//   o1.x <- <PSMain return value>.ColorTarget1_id3.x; o1.y <- <PSMain return value>.ColorTarget1_id3.y; o1.z <- <PSMain return value>.ColorTarget1_id3.z; o1.w <- <PSMain return value>.ColorTarget1_id3.w; 
//   o0.x <- <PSMain return value>.ColorTarget_id2.x; o0.y <- <PSMain return value>.ColorTarget_id2.y; o0.z <- <PSMain return value>.ColorTarget_id2.z; o0.w <- <PSMain return value>.ColorTarget_id2.w
//
#line 1102 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_9546d91ef4de061e1ba089cf6d102d2b.hlsl"
div r0.xy, v3.xyxx, v3.wwww  // r0.x <- streams.ScreenPosition_id170.x; r0.y <- streams.ScreenPosition_id170.y

#line 1069
dp3 r0.z, v2.yzwy, v2.yzwy
lt r0.w, l(0.000000), r0.z

#line 1070
rsq r0.z, r0.z
mul r1.xyz, r0.zzzz, v2.yzwy  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z
movc r1.xyz, r0.wwww, r1.xyzx, v2.yzwy

#line 854
movc r1.xyz, v4.xxxx, r1.xyzx, -r1.xyzx  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z

#line 868
mov r2.xyz, r1.xyzx  // r2.x <- streams.normalWS_id19.x; r2.y <- streams.normalWS_id19.y; r2.z <- streams.normalWS_id19.z
mov r3.xyz, l(0,0,0,0)  // r3.x <- directLightingContribution.x; r3.y <- directLightingContribution.y; r3.z <- directLightingContribution.z
mov r4.xyz, cb1[0].xyzx  // r4.x <- streams.matDiffuseVisible_id69.x; r4.y <- streams.matDiffuseVisible_id69.y; r4.z <- streams.matDiffuseVisible_id69.z
mov r0.z, l(0)  // r0.z <- i
loop 
  ige r0.w, r0.z, l(8)
  breakc_nz r0.w

#line 870
  ige r0.w, r0.z, cb2[25].x
  if_nz r0.w

#line 872
    break 

#line 873
  endif 

#line 686
  ishl r0.w, r0.z, l(1)

#line 794
  dp3 r1.w, r2.xyzx, -cb2[r0.w + 26].xyzx
  max r1.w, r1.w, l(0.000100)  // r1.w <- streams.NdotL_id49

#line 796
  mul r5.xyz, r1.wwww, cb2[r0.w + 27].xyzx  // r5.x <- streams.lightColorNdotL_id44.x; r5.y <- streams.lightColorNdotL_id44.y; r5.z <- streams.lightColorNdotL_id44.z

#line 782
  mul r5.xyz, r5.xyzx, r4.xyzx

#line 878
  mad r3.xyz, r5.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r3.xyzx

#line 868
  iadd r0.z, r0.z, l(1)

#line 880
endloop 

#line 894
ilt r0.z, l(0), cb2[41].w
if_nz r0.z

#line 760
  dp3 r0.z, r1.xyzx, -cb2[42].xyzx
  max r0.z, r0.z, l(0.000100)  // r0.z <- streams.NdotL_id49

#line 631
  lt r0.w, cb2[99].x, v2.x

#line 634
  and r0.w, r0.w, l(1)  // r0.w <- cascadeIndex

#line 631
  lt r1.w, cb2[100].x, v2.x

#line 634
  movc r0.w, r1.w, l(2), r0.w

#line 631
  lt r1.w, cb2[101].x, v2.x

#line 634
  movc r0.w, r1.w, l(3), r0.w

#line 544
  add r2.x, -r0.z, l(1.000000)
  max r2.x, r2.x, l(0.000000)  // r2.x <- normalOffsetScale

#line 545
  mul r2.y, cb2[44].z, cb2[98].x
  dp2 r2.x, r2.yyyy, r2.xxxx

#line 639
  mad r2.xyz, r2.xxxx, r1.xyzx, v0.xyzx  // r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z

#line 537
  ishl r3.w, r0.w, l(2)
  mov r2.w, l(1.000000)
  dp4 r4.x, r2.xyzw, cb2[r3.w + 45].xyzw  // r4.x <- shadowPosition.x
  dp4 r4.y, r2.xyzw, cb2[r3.w + 46].xyzw  // r4.y <- shadowPosition.y
  dp4 r4.w, r2.xyzw, cb2[r3.w + 47].xyzw  // r4.w <- shadowPosition.z
  dp4 r5.x, r2.xyzw, cb2[r3.w + 48].xyzw  // r5.x <- shadowPosition.w

#line 538
  add r4.z, r4.w, -cb2[97].x  // r4.z <- shadowPosition.z

#line 539
  div r4.xyz, r4.xyzx, r5.xxxx

#line 453
  mad r4.xy, r4.xyxx, cb2[44].xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  round_ni r5.xy, r4.xyxx  // r5.x <- base_uv.x; r5.y <- base_uv.y

#line 454
  add r4.xy, r4.xyxx, -r5.xyxx  // r4.x <- st.x; r4.y <- st.y

#line 455
  add r5.xy, r5.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)

#line 456
  mul r5.xy, r5.xyxx, cb2[44].zwzz

#line 317
  mad r5.zw, -r4.yyyx, l(0.000000, 0.000000, 3.000000, 3.000000), l(0.000000, 0.000000, 4.000000, 4.000000)  // r5.z <- uvW0.y; r5.w <- uvW0.x

#line 319
  mad r6.xy, r4.xyxx, l(3.000000, 3.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)  // r6.x <- uvW2.x; r6.y <- uvW2.y

#line 320
  mad r6.zw, -r4.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
  div r6.zw, r6.zzzw, r5.wwwz
  add r7.xw, r6.zzzw, l(-2.000000, 0.000000, 0.000000, -2.000000)  // r7.x <- uv0.x; r7.w <- uv0.y

#line 321
  add r6.zw, r4.xxxy, l(0.000000, 0.000000, 3.000000, 3.000000)
  mul r7.yz, r6.wwzw, l(0.000000, 0.142857, 0.142857, 0.000000)  // r7.y <- uv1.y; r7.z <- uv1.x

#line 322
  div r4.xy, r4.xyxx, r6.xyxx
  add r8.xy, r4.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000)  // r8.x <- uv2.x; r8.y <- uv2.y

#line 323
  mul r4.x, r5.z, r5.w

#line 324
  mad r9.xyzw, r7.xwzw, cb2[44].zwzw, r5.xyxy

#line 328
  mov r8.zw, r7.wwwy

#line 326
  mul r4.yw, r5.zzzw, l(0.000000, 7.000000, 0.000000, 7.000000)

#line 327
  mad r10.xyzw, r7.xyzy, cb2[44].zwzw, r5.xyxy

#line 328
  mad r11.xyzw, r8.xzxw, cb2[44].zwzw, r5.xyxy

#line 329
  mov r7.y, r8.y
  mul r5.zw, r5.zzzw, r6.xxxy

#line 330
  mad r7.xyzw, r7.xyzy, cb2[44].zwzw, r5.xyxy
  mul r6.zw, r6.xxxy, l(0.000000, 0.000000, 7.000000, 7.000000)

#line 331
  mad r5.xy, r8.xyxx, cb2[44].zwzz, r5.xyxx
  mul r6.x, r6.y, r6.x

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r6.y, r9.xyxx, t0.xxxx, s0, r4.z  // r6.y <- <SampleTextureAndCompare_id66 return value>
  sample_c_lz_indexable(texture2d)(float,float,float,float) r8.x, r9.zwzz, t0.xxxx, s0, r4.z  // r8.x <- <SampleTextureAndCompare_id66 return value>

#line 507
  mul r4.y, r4.y, r8.x
  mad r4.x, r4.x, r6.y, r4.y  // r4.x <- shadow

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r11.xyxx, t0.xxxx, s0, r4.z  // r4.y <- <SampleTextureAndCompare_id66 return value>

#line 507
  mad r4.x, r5.z, r4.y, r4.x

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r10.xyxx, t0.xxxx, s0, r4.z

#line 507
  mad r4.x, r4.w, r4.y, r4.x

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r10.zwzz, t0.xxxx, s0, r4.z

#line 507
  mad r4.x, r4.y, l(49.000000), r4.x

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r11.zwzz, t0.xxxx, s0, r4.z

#line 507
  mad r4.x, r6.z, r4.y, r4.x

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r7.xyxx, t0.xxxx, s0, r4.z

#line 507
  mad r4.x, r5.w, r4.y, r4.x

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r7.zwzz, t0.xxxx, s0, r4.z

#line 507
  mad r4.x, r6.w, r4.y, r4.x

#line 448
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r5.xyxx, t0.xxxx, s0, r4.z

#line 507
  mad r4.x, r6.x, r4.y, r4.x

#line 509
  mul r4.yzw, r4.xxxx, l(0.000000, 0.006944, 0.006944, 0.006944)  // r4.w <- shadow

#line 645
  ilt r5.x, l(0), r0.w
  if_nz r5.x

#line 647
    iadd r5.x, r0.w, l(-1)
    add r5.x, -cb2[r5.x + 99].x, cb2[r0.w + 99].x  // r5.x <- splitSize

#line 648
  else 
    mov r5.x, cb2[r0.w + 99].x  // r5.x <- splitSize
  endif 

#line 649
  add r0.w, -v2.x, cb2[r0.w + 99].x
  div r0.w, r0.w, r5.x  // r0.w <- splitDist

#line 650
  lt r5.x, r0.w, l(0.200000)
  if_nz r5.x

#line 653
    if_nz r1.w

#line 655
      mov r4.yzw, r4.wwww  // r4.y <- shadow.x; r4.z <- shadow.y; r4.w <- shadow.z
    else 

#line 652
      mul_sat r0.w, r0.w, l(5.000000)
      mad r1.w, r0.w, l(-2.000000), l(3.000000)
      mul r0.w, r0.w, r0.w
      mul r0.w, r0.w, r1.w  // r0.w <- lerpAmt

#line 537
      dp4 r5.x, r2.xyzw, cb2[r3.w + 49].xyzw  // r5.x <- shadowPosition.x
      dp4 r5.y, r2.xyzw, cb2[r3.w + 50].xyzw  // r5.y <- shadowPosition.y
      dp4 r1.w, r2.xyzw, cb2[r3.w + 51].xyzw  // r1.w <- shadowPosition.z
      dp4 r2.x, r2.xyzw, cb2[r3.w + 52].xyzw  // r2.x <- shadowPosition.w

#line 538
      add r5.z, r1.w, -cb2[97].x  // r5.z <- shadowPosition.z

#line 539
      div r2.xyz, r5.xyzx, r2.xxxx  // r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z

#line 453
      mad r2.xy, r2.xyxx, cb2[44].xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
      round_ni r5.xy, r2.xyxx  // r5.x <- base_uv.x; r5.y <- base_uv.y

#line 454
      add r2.xy, r2.xyxx, -r5.xyxx  // r2.x <- st.x; r2.y <- st.y

#line 455
      add r5.xy, r5.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)

#line 456
      mul r5.xy, r5.xyxx, cb2[44].zwzz

#line 317
      mad r5.zw, -r2.yyyx, l(0.000000, 0.000000, 3.000000, 3.000000), l(0.000000, 0.000000, 4.000000, 4.000000)  // r5.z <- uvW0.y; r5.w <- uvW0.x

#line 319
      mad r6.xy, r2.xyxx, l(3.000000, 3.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)  // r6.x <- uvW2.x; r6.y <- uvW2.y

#line 320
      mad r6.zw, -r2.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
      div r6.zw, r6.zzzw, r5.wwwz
      add r7.xw, r6.zzzw, l(-2.000000, 0.000000, 0.000000, -2.000000)  // r7.x <- uv0.x; r7.w <- uv0.y

#line 321
      add r6.zw, r2.xxxy, l(0.000000, 0.000000, 3.000000, 3.000000)
      mul r7.yz, r6.wwzw, l(0.000000, 0.142857, 0.142857, 0.000000)  // r7.y <- uv1.y; r7.z <- uv1.x

#line 322
      div r2.xy, r2.xyxx, r6.xyxx
      add r8.xy, r2.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000)  // r8.x <- uv2.x; r8.y <- uv2.y

#line 323
      mul r1.w, r5.z, r5.w

#line 324
      mad r9.xyzw, r7.xwzw, cb2[44].zwzw, r5.xyxy

#line 328
      mov r8.zw, r7.wwwy

#line 326
      mul r2.xy, r5.zwzz, l(7.000000, 7.000000, 0.000000, 0.000000)

#line 327
      mad r10.xyzw, r7.xyzy, cb2[44].zwzw, r5.xyxy

#line 328
      mad r11.xyzw, r8.xzxw, cb2[44].zwzw, r5.xyxy

#line 329
      mov r7.y, r8.y
      mul r5.zw, r5.zzzw, r6.xxxy

#line 330
      mad r7.xyzw, r7.xyzy, cb2[44].zwzw, r5.xyxy
      mul r6.zw, r6.xxxy, l(0.000000, 0.000000, 7.000000, 7.000000)

#line 331
      mad r5.xy, r8.xyxx, cb2[44].zwzz, r5.xyxx
      mul r2.w, r6.y, r6.x

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.w, r9.xyxx, t0.xxxx, s0, r2.z  // r3.w <- <SampleTextureAndCompare_id66 return value>
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r9.zwzz, t0.xxxx, s0, r2.z  // r6.x <- <SampleTextureAndCompare_id66 return value>

#line 507
      mul r2.x, r2.x, r6.x
      mad r1.w, r1.w, r3.w, r2.x  // r1.w <- shadow

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r11.xyxx, t0.xxxx, s0, r2.z  // r2.x <- <SampleTextureAndCompare_id66 return value>

#line 507
      mad r1.w, r5.z, r2.x, r1.w

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r10.xyxx, t0.xxxx, s0, r2.z

#line 507
      mad r1.w, r2.y, r2.x, r1.w

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r10.zwzz, t0.xxxx, s0, r2.z

#line 507
      mad r1.w, r2.x, l(49.000000), r1.w

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r11.zwzz, t0.xxxx, s0, r2.z

#line 507
      mad r1.w, r6.z, r2.x, r1.w

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r7.xyxx, t0.xxxx, s0, r2.z

#line 507
      mad r1.w, r5.w, r2.x, r1.w

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r7.zwzz, t0.xxxx, s0, r2.z

#line 507
      mad r1.w, r6.w, r2.x, r1.w

#line 448
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r5.xyxx, t0.xxxx, s0, r2.z

#line 507
      mad r1.w, r2.w, r2.x, r1.w

#line 509
      mul r1.w, r1.w, l(0.006944)

#line 659
      mad r2.x, r4.x, l(0.006944), -r1.w
      mad r4.yzw, r0.wwww, r2.xxxx, r1.wwww  // r4.y <- shadow.x; r4.z <- shadow.y; r4.w <- shadow.z

#line 660
    endif 

#line 661
  endif 

#line 762
  mul r2.xyz, r4.yzwy, cb2[43].xyzx
  mul r2.xyz, r0.zzzz, r2.xyzx  // r2.x <- streams.lightColorNdotL_id44.x; r2.y <- streams.lightColorNdotL_id44.y; r2.z <- streams.lightColorNdotL_id44.z

#line 782
  mul r2.xyz, r2.xyzx, cb1[0].xyzx

#line 898
  mad r3.xyz, r2.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r3.xyzx

#line 899
endif 

#line 608
add r0.z, v1.z, -cb2[22].z
div r0.z, cb2[22].w, r0.z  // r0.z <- depth

#line 609
mad r0.xy, r0.xyxx, l(1.000000, -1.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
mul r0.xy, r0.xyxx, cb2[103].xyxx

#line 610
mad r0.z, r0.z, cb2[102].y, cb2[102].z
log r0.z, r0.z
max r0.z, r0.z, l(0.000000)

#line 611
mul r0.xy, r0.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)

#line 610
ftoi r2.xyz, r0.xyzx  // r2.z <- slice

#line 611
mov r2.w, l(0)
ld_indexable(texture3d)(uint,uint,uint,uint) r0.xy, r2.xyzw, t1.xyzw  // r0.x <- streams.lightData_id176.x; r0.y <- streams.lightData_id176.y

#line 751
and r0.z, r0.y, l(0x0000ffff)  // r0.z <- <GetMaxLightCount_id163 return value>

#line 908
mov r2.xyz, r1.xyzx  // r2.x <- streams.normalWS_id19.x; r2.y <- streams.normalWS_id19.y; r2.z <- streams.normalWS_id19.z
mov r2.w, v0.x  // r2.w <- streams.PositionWS_id22.x
mov r4.yz, v0.yyzy  // r4.y <- streams.PositionWS_id22.y; r4.z <- streams.PositionWS_id22.z
mov r5.xyz, cb1[0].xyzx  // r5.x <- streams.matDiffuseVisible_id69.x; r5.y <- streams.matDiffuseVisible_id69.y; r5.z <- streams.matDiffuseVisible_id69.z
mov r6.xyz, r3.xyzx  // r6.x <- directLightingContribution.x; r6.y <- directLightingContribution.y; r6.z <- directLightingContribution.z
mov r7.x, r0.x  // r7.x <- streams.lightIndex_id177
mov r0.w, l(0)  // r0.w <- i
loop 
  ige r1.w, r0.w, r0.z
  breakc_nz r1.w

#line 910
  if_nz r1.w

#line 912
    break 

#line 913
  endif 

#line 595
  ld_indexable(buffer)(uint,uint,uint,uint) r1.w, r7.xxxx, t2.yzwx  // r1.w <- realLightIndex

#line 596
  iadd r7.x, r7.x, l(1)  // r7.x <- streams.lightIndex_id177

#line 598
  ishl r3.w, r1.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r8.xyzw, r3.wwww, t3.xyzw  // r8.x <- pointLight1.x; r8.y <- pointLight1.y; r8.z <- pointLight1.z; r8.w <- pointLight1.w

#line 599
  bfi r1.w, l(31), l(1), r1.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r7.yzw, r1.wwww, t3.wxyz  // r7.y <- pointLight2.x; r7.z <- pointLight2.y; r7.w <- pointLight2.z

#line 473
  mov r4.x, r2.w
  add r8.xyz, -r4.xyzx, r8.xyzx  // r8.x <- lightVector.x; r8.y <- lightVector.y; r8.z <- lightVector.z

#line 474
  dp3 r1.w, r8.xyzx, r8.xyzx
  sqrt r3.w, r1.w  // r3.w <- lightVectorLength

#line 475
  div r8.xyz, r8.xyzx, r3.wwww  // r8.x <- lightVectorNorm.x; r8.y <- lightVectorNorm.y; r8.z <- lightVectorNorm.z

#line 394
  max r3.w, r1.w, l(0.000100)
  div r3.w, l(1.000000, 1.000000, 1.000000, 1.000000), r3.w  // r3.w <- attenuation

#line 299
  mul r1.w, r8.w, r1.w  // r1.w <- factor

#line 300
  mad r1.w, -r1.w, r1.w, l(1.000000)
  max r1.w, r1.w, l(0.000000)  // r1.w <- smoothFactor

#line 301
  mul r1.w, r1.w, r1.w  // r1.w <- <SmoothDistanceAttenuation_id80 return value>

#line 395
  mul r1.w, r1.w, r3.w  // r1.w <- attenuation

#line 737
  dp3 r3.w, r2.xyzx, r8.xyzx
  max r3.w, r3.w, l(0.000100)  // r3.w <- streams.NdotL_id49

#line 739
  mul r7.yzw, r1.wwww, r7.yyzw
  mul r7.yzw, r3.wwww, r7.yyzw  // r7.y <- streams.lightColorNdotL_id44.x; r7.z <- streams.lightColorNdotL_id44.y; r7.w <- streams.lightColorNdotL_id44.z

#line 782
  mul r7.yzw, r7.yyzw, r5.xxyz

#line 918
  mad r6.xyz, r7.yzwy, l(0.318310, 0.318310, 0.318310, 0.000000), r6.xyzx

#line 908
  iadd r0.w, r0.w, l(1)

#line 920
endloop   // r7.x <- streams.lightIndex_id177

#line 729
ushr r0.x, r0.y, l(16)  // r0.x <- <GetMaxLightCount_id175 return value>

#line 928
mov r2.xyz, r1.xyzx
mov r2.w, v0.x
mov r3.yz, v0.yyzy  // r3.y <- streams.PositionWS_id22.y; r3.z <- streams.PositionWS_id22.z
mov r0.yzw, cb1[0].xxyz  // r0.y <- streams.matDiffuseVisible_id69.x; r0.z <- streams.matDiffuseVisible_id69.y; r0.w <- streams.matDiffuseVisible_id69.z
mov r4.xyz, r6.xyzx  // r4.x <- directLightingContribution.x; r4.y <- directLightingContribution.y; r4.z <- directLightingContribution.z
mov r1.w, r7.x  // r1.w <- streams.lightIndex_id177
mov r3.w, l(0)  // r3.w <- i
loop 
  ige r4.w, r3.w, r0.x
  breakc_nz r4.w

#line 930
  if_nz r4.w

#line 932
    break 

#line 933
  endif 

#line 567
  ld_indexable(buffer)(uint,uint,uint,uint) r4.w, r1.wwww, t2.yzwx  // r4.w <- realLightIndex

#line 568
  iadd r1.w, r1.w, l(1)  // r1.w <- streams.lightIndex_id177

#line 570
  ishl r5.x, r4.w, l(2)
  ld_indexable(buffer)(float,float,float,float) r5.xyz, r5.xxxx, t4.xyzw  // r5.x <- spotLight1.x; r5.y <- spotLight1.y; r5.z <- spotLight1.z

#line 573
  bfi r7.yzw, l(0, 30, 30, 30), l(0, 2, 2, 2), r4.wwww, l(0, 1, 2, 3)

#line 571
  ld_indexable(buffer)(float,float,float,float) r8.xyz, r7.yyyy, t4.xyzw  // r8.x <- spotLight2.x; r8.y <- spotLight2.y; r8.z <- spotLight2.z

#line 572
  ld_indexable(buffer)(float,float,float,float) r9.xyz, r7.zzzz, t4.xyzw  // r9.x <- spotLight3.x; r9.y <- spotLight3.y; r9.z <- spotLight3.z

#line 573
  ld_indexable(buffer)(float,float,float,float) r7.yzw, r7.wwww, t4.wxyz  // r7.y <- spotLight4.x; r7.z <- spotLight4.y; r7.w <- spotLight4.z

#line 460
  mov r3.x, r2.w
  add r5.xyz, -r3.xyzx, r5.xyzx  // r5.x <- lightVector.x; r5.y <- lightVector.y; r5.z <- lightVector.z

#line 461
  dp3 r3.x, r5.xyzx, r5.xyzx
  sqrt r4.w, r3.x  // r4.w <- lightVectorLength

#line 462
  div r5.xyz, r5.xyzx, r4.wwww  // r5.x <- lightVectorNorm.x; r5.y <- lightVectorNorm.y; r5.z <- lightVectorNorm.z

#line 387
  max r4.w, r3.x, l(0.000100)
  div r4.w, l(1.000000, 1.000000, 1.000000, 1.000000), r4.w  // r4.w <- attenuation

#line 293
  mul r3.x, r9.z, r3.x  // r3.x <- factor

#line 294
  mad r3.x, -r3.x, r3.x, l(1.000000)
  max r3.x, r3.x, l(0.000000)  // r3.x <- smoothFactor

#line 295
  mul r3.x, r3.x, r3.x  // r3.x <- <SmoothDistanceAttenuation_id91 return value>

#line 388
  mul r3.x, r3.x, r4.w  // r3.x <- attenuation

#line 379
  dp3 r4.w, -r8.xyzx, r5.xyzx  // r4.w <- cd

#line 380
  mad_sat r4.w, r4.w, r9.x, r9.y  // r4.w <- attenuation

#line 381
  mul r4.w, r4.w, r4.w

#line 468
  mul r3.x, r3.x, r4.w  // r3.x <- attenuation

#line 715
  dp3 r4.w, r2.xyzx, r5.xyzx
  max r4.w, r4.w, l(0.000100)  // r4.w <- streams.NdotL_id49

#line 717
  mul r5.xyz, r3.xxxx, r7.yzwy
  mul r5.xyz, r4.wwww, r5.xyzx  // r5.x <- streams.lightColorNdotL_id44.x; r5.y <- streams.lightColorNdotL_id44.y; r5.z <- streams.lightColorNdotL_id44.z

#line 782
  mul r5.xyz, r0.yzwy, r5.xyzx

#line 938
  mad r4.xyz, r5.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r4.xyzx

#line 928
  iadd r3.w, r3.w, l(1)

#line 940
endloop   // r1.w <- streams.lightIndex_id177

#line 703
mul r0.xyz, cb1[0].xyzx, cb2[104].xyzx  // r0.x <- <ComputeEnvironmentLightContribution_id188 return value>.x; r0.y <- <ComputeEnvironmentLightContribution_id188 return value>.y; r0.z <- <ComputeEnvironmentLightContribution_id188 return value>.z

#line 959
mad o0.xyz, r4.xyzx, l(3.141593, 3.141593, 3.141593, 0.000000), r0.xyzx

#line 1039
utof o1.xyzw, cb0[26].xxxx

#line 1107
mov o0.w, cb1[0].w
ret 
// Approximately 274 instruction slots used
***************************
*************************/
const static int TMaxLightCount_id87 = 8;
const static int TMaxLightCount_id90 = 1;
const static int TCascadeCountBase_id154 = 4;
const static int TLightCountBase_id155 = 1;
const static int TCascadeCount_id162 = 4;
const static int TLightCount_id163 = 1;
const static bool TBlendCascades_id164 = true;
const static bool TDepthRangeAuto_id165 = true;
const static bool TCascadeDebug_id166 = false;
const static bool TComputeTransmittance_id167 = false;
const static int TFilterSize_id169 = 5;
static const float PI_id189 = 3.14159265358979323846;
const static bool TIsEnergyConservative_id190 = false;
struct PS_STREAMS 
{
    float4 ScreenPosition_id170;
    float3 normalWS_id19;
    float4 PositionWS_id22;
    float DepthVS_id23;
    float4 ShadingPosition_id0;
    bool IsFrontFace_id1;
    float3 meshNormalWS_id17;
    float3 viewWS_id68;
    float3 shadingColor_id73;
    float matBlend_id40;
    float3 matNormal_id51;
    float4 matColorBase_id52;
    float4 matDiffuse_id53;
    float3 matDiffuseVisible_id69;
    float3 matSpecular_id55;
    float3 matSpecularVisible_id71;
    float matSpecularIntensity_id56;
    float matGlossiness_id54;
    float alphaRoughness_id70;
    float matAmbientOcclusion_id57;
    float matAmbientOcclusionDirectLightingFactor_id58;
    float matCavity_id59;
    float matCavityDiffuse_id60;
    float matCavitySpecular_id61;
    float4 matEmissive_id62;
    float matEmissiveIntensity_id63;
    float matScatteringStrength_id64;
    float2 matDiffuseSpecularAlphaBlend_id65;
    float3 matAlphaBlendColor_id66;
    float matAlphaDiscard_id67;
    float shadingColorAlpha_id74;
    float3 lightPositionWS_id41;
    float3 lightDirectionWS_id42;
    float3 lightColor_id43;
    float3 lightColorNdotL_id44;
    float3 lightSpecularColorNdotL_id45;
    float lightAttenuation_id46;
    float3 envLightDiffuseColor_id47;
    float3 envLightSpecularColor_id48;
    float lightDirectAmbientOcclusion_id50;
    float NdotL_id49;
    float NdotV_id72;
    float thicknessWS_id85;
    float3 shadowColor_id84;
    float3 H_id75;
    float NdotH_id76;
    float LdotH_id77;
    float VdotH_id78;
    uint2 lightData_id176;
    int lightIndex_id177;
    float4 ColorTarget_id2;
    float4 ColorTarget1_id3;
};
struct PS_OUTPUT 
{
    float4 ColorTarget_id2 : SV_Target0;
    float4 ColorTarget1_id3 : SV_Target1;
};
struct PS_INPUT 
{
    float4 PositionWS_id22 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float DepthVS_id23 : DEPTH_VS;
    float3 normalWS_id19 : NORMALWS;
    float4 ScreenPosition_id170 : SCREENPOSITION_ID170_SEM;
    bool IsFrontFace_id1 : SV_IsFrontFace;
};
struct VS_STREAMS 
{
    float4 Position_id21;
    float3 meshNormal_id16;
    float4 PositionH_id24;
    float3 meshNormalWS_id17;
    float4 PositionWS_id22;
    float4 ShadingPosition_id0;
    float DepthVS_id23;
    float3 normalWS_id19;
    float4 ScreenPosition_id170;
};
struct VS_OUTPUT 
{
    float4 PositionWS_id22 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float DepthVS_id23 : DEPTH_VS;
    float3 normalWS_id19 : NORMALWS;
    float4 ScreenPosition_id170 : SCREENPOSITION_ID170_SEM;
};
struct VS_INPUT 
{
    float4 Position_id21 : POSITION;
    float3 meshNormal_id16 : NORMAL;
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
    float4x4 World_id32;
    float4x4 WorldInverse_id33;
    float4x4 WorldInverseTranspose_id34;
    float4x4 WorldView_id35;
    float4x4 WorldViewInverse_id36;
    float4x4 WorldViewProjection_id37;
    float3 WorldScale_id38;
    float4 EyeMS_id39;
    uint MaterialIndex_id83;
};
cbuffer PerMaterial 
{
    float4 constantColor_id186;
};
cbuffer PerView 
{
    float4x4 View_id25;
    float4x4 ViewInverse_id26;
    float4x4 Projection_id27;
    float4x4 ProjectionInverse_id28;
    float4x4 ViewProjection_id29;
    float2 ProjScreenRay_id30;
    float4 Eye_id31;
    float NearClipPlane_id171 = 1.0f;
    float FarClipPlane_id172 = 100.0f;
    float2 ZProjection_id173;
    float2 ViewSize_id174;
    float AspectRatio_id175;
    float4 _padding_PerView_Default;
    int LightCount_id86;
    DirectionalLightData Lights_id88[TMaxLightCount_id87];
    int LightCount_id89;
    DirectionalLightData Lights_id91[TMaxLightCount_id90];
    float2 ShadowMapTextureSize_id93;
    float2 ShadowMapTextureTexelSize_id94;
    float4x4 WorldToShadowCascadeUV_id156[TCascadeCountBase_id154 * TLightCountBase_id155];
    float4x4 InverseWorldToShadowCascadeUV_id157[TCascadeCountBase_id154 * TLightCountBase_id155];
    float4x4 ViewMatrices_id158[TCascadeCountBase_id154 * TLightCountBase_id155];
    float2 DepthRanges_id159[TCascadeCountBase_id154 * TLightCountBase_id155];
    float DepthBiases_id160[TLightCountBase_id155];
    float OffsetScales_id161[TLightCountBase_id155];
    float CascadeDepthSplits_id168[TCascadeCount_id162 * TLightCount_id163];
    float ClusterDepthScale_id180;
    float ClusterDepthBias_id181;
    float2 ClusterStride_id182;
    float3 AmbientLight_id185;
    float4 _padding_PerView_Lighting;
};
cbuffer Globals 
{
    float2 Texture0TexelSize_id96;
    float2 Texture1TexelSize_id98;
    float2 Texture2TexelSize_id100;
    float2 Texture3TexelSize_id102;
    float2 Texture4TexelSize_id104;
    float2 Texture5TexelSize_id106;
    float2 Texture6TexelSize_id108;
    float2 Texture7TexelSize_id110;
    float2 Texture8TexelSize_id112;
    float2 Texture9TexelSize_id114;
};
Texture2D Texture0_id95;
Texture2D Texture1_id97;
Texture2D Texture2_id99;
Texture2D Texture3_id101;
Texture2D Texture4_id103;
Texture2D Texture5_id105;
Texture2D Texture6_id107;
Texture2D Texture7_id109;
Texture2D Texture8_id111;
Texture2D Texture9_id113;
TextureCube TextureCube0_id115;
TextureCube TextureCube1_id116;
TextureCube TextureCube2_id117;
TextureCube TextureCube3_id118;
Texture3D Texture3D0_id119;
Texture3D Texture3D1_id120;
Texture3D Texture3D2_id121;
Texture3D Texture3D3_id122;
SamplerState Sampler_id123;
SamplerState PointSampler_id124 
{
    Filter = MIN_MAG_MIP_POINT;
};
SamplerState LinearSampler_id125 
{
    Filter = MIN_MAG_MIP_LINEAR;
};
SamplerState LinearBorderSampler_id126 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Border;
    AddressV = Border;
};
SamplerComparisonState LinearClampCompareLessEqualSampler_id127 
{
    Filter = COMPARISON_MIN_MAG_LINEAR_MIP_POINT;
    AddressU = Clamp;
    AddressV = Clamp;
    ComparisonFunc = LessEqual;
};
SamplerState AnisotropicSampler_id128 
{
    Filter = ANISOTROPIC;
};
SamplerState AnisotropicRepeatSampler_id129 
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
    MaxAnisotropy = 16;
};
SamplerState PointRepeatSampler_id130 
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState LinearRepeatSampler_id131 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState RepeatSampler_id132 
{
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState Sampler0_id133;
SamplerState Sampler1_id134;
SamplerState Sampler2_id135;
SamplerState Sampler3_id136;
SamplerState Sampler4_id137;
SamplerState Sampler5_id138;
SamplerState Sampler6_id139;
SamplerState Sampler7_id140;
SamplerState Sampler8_id141;
SamplerState Sampler9_id142;
Texture2D ShadowMapTexture_id92;
Texture3D<uint2> LightClusters_id178;
Buffer<uint> LightIndices_id179;
Buffer<float4> PointLights_id183;
Buffer<float4> SpotLights_id184;
float4 Project_id58(float4 vec, float4x4 mat)
{
    float4 vecProjected = mul(vec, mat);
    vecProjected.xyz /= vecProjected.w;
    return vecProjected;
}
float SmoothDistanceAttenuation_id91(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float SmoothDistanceAttenuation_id80(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float Get3x3FilterKernel_id68(float2 base_uv, float2 st, out float3 kernel[4])
{
    float2 uvW0 = (3 - 2 * st);
    float2 uvW1 = (1 + 2 * st);
    float2 uv0 = (2 - st) / uvW0 - 1;
    float2 uv1 = st / uvW1 + 1;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id94, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id94, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id94, uvW0.x * uvW1.y);
    kernel[3] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id94, uvW1.x * uvW1.y);
    return 16.0;
}
float Get5x5FilterKernel_id67(float2 base_uv, float2 st, out float3 kernel[9])
{
    float2 uvW0 = (4 - 3 * st);
    float2 uvW1 = 7;
    float2 uvW2 = (1 + 3 * st);
    float2 uv0 = (3 - 2 * st) / uvW0 - 2;
    float2 uv1 = (3 + st) / uvW1;
    float2 uv2 = st / uvW2 + 2;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id94, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id94, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv2.x, uv0.y) * ShadowMapTextureTexelSize_id94, uvW2.x * uvW0.y);
    kernel[3] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id94, uvW0.x * uvW1.y);
    kernel[4] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id94, uvW1.x * uvW1.y);
    kernel[5] = float3(base_uv + float2(uv2.x, uv1.y) * ShadowMapTextureTexelSize_id94, uvW2.x * uvW1.y);
    kernel[6] = float3(base_uv + float2(uv0.x, uv2.y) * ShadowMapTextureTexelSize_id94, uvW0.x * uvW2.y);
    kernel[7] = float3(base_uv + float2(uv1.x, uv2.y) * ShadowMapTextureTexelSize_id94, uvW1.x * uvW2.y);
    kernel[8] = float3(base_uv + uv2 * ShadowMapTextureTexelSize_id94, uvW2.x * uvW2.y);
    return 144.0;
}
float SampleThickness_id69(float3 shadowSpaceCoordinate, float3 pixelPositionWS, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float shadowMapDepth = ShadowMapTexture_id92.SampleLevel(LinearBorderSampler_id126, shadowSpaceCoordinate.xy, 0).r;
    float thickness;
    if (isOrthographic)
    {
        thickness = abs(shadowMapDepth - shadowSpaceCoordinate.z) * depthRanges.y;
    }
    else
    {
        float4 shadowmapPositionWorldSpace = Project_id58(float4(shadowSpaceCoordinate.xy, shadowMapDepth, 1.0), inverseWorldToShadowCascadeUV);
        thickness = distance(shadowmapPositionWorldSpace.xyz, pixelPositionWS.xyz);
    }
    return (thickness);
}
float Get7x7FilterKernel_id65(float2 base_uv, float2 st, out float3 kernel[16])
{
    float2 uvW0 = (5 * st - 6);
    float2 uvW1 = (11 * st - 28);
    float2 uvW2 = -(11 * st + 17);
    float2 uvW3 = -(5 * st + 1);
    float2 uv0 = (4 * st - 5) / uvW0 - 3;
    float2 uv1 = (4 * st - 16) / uvW1 - 1;
    float2 uv2 = -(7 * st + 5) / uvW2 + 1;
    float2 uv3 = -st / uvW3 + 3;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id94, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id94, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv2.x, uv0.y) * ShadowMapTextureTexelSize_id94, uvW2.x * uvW0.y);
    kernel[3] = float3(base_uv + float2(uv3.x, uv0.y) * ShadowMapTextureTexelSize_id94, uvW3.x * uvW0.y);
    kernel[4] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id94, uvW0.x * uvW1.y);
    kernel[5] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id94, uvW1.x * uvW1.y);
    kernel[6] = float3(base_uv + float2(uv2.x, uv1.y) * ShadowMapTextureTexelSize_id94, uvW2.x * uvW1.y);
    kernel[7] = float3(base_uv + float2(uv3.x, uv1.y) * ShadowMapTextureTexelSize_id94, uvW3.x * uvW1.y);
    kernel[8] = float3(base_uv + float2(uv0.x, uv2.y) * ShadowMapTextureTexelSize_id94, uvW0.x * uvW2.y);
    kernel[9] = float3(base_uv + float2(uv1.x, uv2.y) * ShadowMapTextureTexelSize_id94, uvW1.x * uvW2.y);
    kernel[10] = float3(base_uv + uv2 * ShadowMapTextureTexelSize_id94, uvW2.x * uvW2.y);
    kernel[11] = float3(base_uv + float2(uv3.x, uv2.y) * ShadowMapTextureTexelSize_id94, uvW3.x * uvW2.y);
    kernel[12] = float3(base_uv + float2(uv0.x, uv3.y) * ShadowMapTextureTexelSize_id94, uvW0.x * uvW3.y);
    kernel[13] = float3(base_uv + float2(uv1.x, uv3.y) * ShadowMapTextureTexelSize_id94, uvW1.x * uvW3.y);
    kernel[14] = float3(base_uv + float2(uv2.x, uv3.y) * ShadowMapTextureTexelSize_id94, uvW2.x * uvW3.y);
    kernel[15] = float3(base_uv + uv3 * ShadowMapTextureTexelSize_id94, uvW3.x * uvW3.y);
    return 2704.0;
}
float GetAngularAttenuation_id93(float3 lightVector, float3 lightDirection, float lightAngleScale, float lightAngleOffset)
{
    float cd = dot(lightDirection, lightVector);
    float attenuation = saturate(cd * lightAngleScale + lightAngleOffset);
    attenuation *= attenuation;
    return attenuation;
}
float GetDistanceAttenuation_id92(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id91(d2, lightInvSquareRadius);
    return attenuation;
}
float GetDistanceAttenuation_id82(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id80(d2, lightInvSquareRadius);
    return attenuation;
}
float SampleAndFilter_id73(float3 adjustedPixelPositionWS, float3 adjustedPixelPositionShadowSpace, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic, bool isDualParaboloid = false)
{
    float2 uv = adjustedPixelPositionShadowSpace.xy * ShadowMapTextureSize_id93;
    float2 base_uv = floor(uv + 0.5);
    float2 st = uv + 0.5 - base_uv;
    base_uv *= ShadowMapTextureTexelSize_id94;
    float thickness = 0.0;
    float normalizationFactor = 1.0;

    {
        float3 kernel[9];
        normalizationFactor = Get5x5FilterKernel_id67(base_uv, st, kernel);

        [unroll]
        for (int i = 0; i < 9; ++i)
        {
            thickness += kernel[i].z * SampleThickness_id69(float3(kernel[i].xy, adjustedPixelPositionShadowSpace.z), adjustedPixelPositionWS, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
        }
    }
    return (thickness / normalizationFactor);
}
void CalculateAdjustedShadowSpacePixelPosition_id72(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    float4 bottomLeftTexelWS = Project_id58(float4(0.0, 0.0, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id58(float4(ShadowMapTextureTexelSize_id94.xy * filterRadiusInPixels, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, bottomLeftTexelWS.xyz);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 shadowMapCoordinate = Project_id58(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = shadowMapCoordinate.xyz;
}
void CalculateAdjustedShadowSpacePixelPositionPerspective_id71(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    const float4 shadowMapCoordinate = Project_id58(float4(pixelPositionWS, 1.0), worldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id58(float4(shadowMapCoordinate.xy + ShadowMapTextureTexelSize_id94.xy * filterRadiusInPixels, shadowMapCoordinate.z, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, pixelPositionWS);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 adjustedShadowMapCoordinate = Project_id58(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = adjustedShadowMapCoordinate.xyz;
}
float GetFilterRadiusInPixels_id70()
{

    {
        return 3.5;
    }
}
float SampleTextureAndCompare_id66(float2 position, float positionDepth)
{
    return ShadowMapTexture_id92.SampleCmpLevelZero(LinearClampCompareLessEqualSampler_id127, position, positionDepth);
}
void CalculatePCFKernelParameters_id64(float2 position, out float2 base_uv, out float2 st)
{
    float2 uv = position * ShadowMapTextureSize_id93;
    base_uv = floor(uv + 0.5);
    st = uv + 0.5 - base_uv;
    base_uv -= 0.5;
    base_uv *= ShadowMapTextureTexelSize_id94;
}
float ComputeAttenuation_id94(float3 PositionWS, float3 AngleOffsetAndInvSquareRadius, float3 DirectionWS, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float3 lightAngleOffsetAndInvSquareRadius = AngleOffsetAndInvSquareRadius;
    float2 lightAngleAndOffset = lightAngleOffsetAndInvSquareRadius.xy;
    float lightInvSquareRadius = lightAngleOffsetAndInvSquareRadius.z;
    float3 lightDirection = -DirectionWS;
    float attenuation = GetDistanceAttenuation_id92(lightVectorLength, lightInvSquareRadius);
    attenuation *= GetAngularAttenuation_id93(lightVectorNorm, lightDirection, lightAngleAndOffset.x, lightAngleAndOffset.y);
    return attenuation;
}
float ComputeAttenuation_id81(PointLightDataInternal light, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = light.PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float lightInvSquareRadius = light.InvSquareRadius;
    return GetDistanceAttenuation_id82(lightVectorLength, lightInvSquareRadius);
}
float FilterThickness_id60(float3 pixelPositionWS, float3 meshNormalWS, float2 depthRanges, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    float3 adjustedPixelPositionWS;
    float3 adjustedPixelPositionShadowSpace;
    if (isOrthographic)
    {
        CalculateAdjustedShadowSpacePixelPosition_id72(GetFilterRadiusInPixels_id70(), pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    else
    {
        CalculateAdjustedShadowSpacePixelPositionPerspective_id71(GetFilterRadiusInPixels_id70(), pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    return SampleAndFilter_id73(adjustedPixelPositionWS, adjustedPixelPositionShadowSpace, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
}
float FilterShadow_id59(float2 position, float positionDepth)
{
    float shadow = 0.0f;
    float2 base_uv;
    float2 st;
    CalculatePCFKernelParameters_id64(position, base_uv, st);

    {
        float3 kernel[9];
        float normalizationFactor = Get5x5FilterKernel_id67(base_uv, st, kernel);

        [unroll]
        for (int i = 0; i < 9; ++i)
        {
            shadow += kernel[i].z * SampleTextureAndCompare_id66(kernel[i].xy, positionDepth);
        }
        shadow /= normalizationFactor;
    }
    return shadow;
}
void ProcessLight_id95(inout PS_STREAMS streams, SpotLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id94(light.PositionWS, light.AngleOffsetAndInvSquareRadius, light.DirectionWS, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
void ProcessLight_id84(inout PS_STREAMS streams, PointLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id81(light, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightPositionWS_id41 = light.PositionWS;
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
float ComputeThicknessFromCascade_id63(float3 pixelPositionWS, float3 meshNormalWS, int cascadeIndex, int lightIndex, bool isOrthographic)
{
    const int arrayIndex = cascadeIndex + lightIndex * TCascadeCountBase_id154;
    return FilterThickness_id60(pixelPositionWS, meshNormalWS, DepthRanges_id159[arrayIndex], WorldToShadowCascadeUV_id156[arrayIndex], InverseWorldToShadowCascadeUV_id157[arrayIndex], isOrthographic);
}
float ComputeShadowFromCascade_id62(float3 shadowPositionWS, int cascadeIndex, int lightIndex)
{
    float4 shadowPosition = mul(float4(shadowPositionWS, 1.0), WorldToShadowCascadeUV_id156[cascadeIndex + lightIndex * TCascadeCountBase_id154]);
    shadowPosition.z -= DepthBiases_id160[lightIndex];
    shadowPosition.xyz /= shadowPosition.w;
    return FilterShadow_id59(shadowPosition.xy, shadowPosition.z);
}
float3 GetShadowPositionOffset_id61(float offsetScale, float nDotL, float3 normal)
{
    float normalOffsetScale = saturate(1.0f - nDotL);
    return 2.0f * ShadowMapTextureTexelSize_id94.x * offsetScale * normalOffsetScale * normal;
}
void PrepareEnvironmentLight_id99(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeSpecularTextureProjection_id90(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id89(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id88(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id87(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id179.Load(streams.lightIndex_id177);
    streams.lightIndex_id177++;
    SpotLightDataInternal spotLight;
    float4 spotLight1 = SpotLights_id184.Load(realLightIndex * 4);
    float4 spotLight2 = SpotLights_id184.Load(realLightIndex * 4 + 1);
    float4 spotLight3 = SpotLights_id184.Load(realLightIndex * 4 + 2);
    float4 spotLight4 = SpotLights_id184.Load(realLightIndex * 4 + 3);
    spotLight.PositionWS = spotLight1.xyz;
    spotLight.DirectionWS = spotLight2.xyz;
    spotLight.AngleOffsetAndInvSquareRadius = spotLight3.xyz;
    spotLight.Color = spotLight4.xyz;
    ProcessLight_id95(streams, spotLight);
}
float3 ComputeSpecularTextureProjection_id79(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id78(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id77(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id76(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id179.Load(streams.lightIndex_id177);
    streams.lightIndex_id177++;
    PointLightDataInternal pointLight;
    float4 pointLight1 = PointLights_id183.Load(realLightIndex * 2);
    float4 pointLight2 = PointLights_id183.Load(realLightIndex * 2 + 1);
    pointLight.PositionWS = pointLight1.xyz;
    pointLight.InvSquareRadius = pointLight1.w;
    pointLight.Color = pointLight2.xyz;
    ProcessLight_id84(streams, pointLight);
}
void PrepareLightData_id83(inout PS_STREAMS streams)
{
    float projectedDepth = streams.ShadingPosition_id0.z;
    float depth = ZProjection_id173.y / (projectedDepth - ZProjection_id173.x);
    float2 texCoord = float2(streams.ScreenPosition_id170.x + 1, 1 - streams.ScreenPosition_id170.y) * 0.5;
    int slice = int(max(log2(depth * ClusterDepthScale_id180 + ClusterDepthBias_id181), 0));
    streams.lightData_id176 = LightClusters_id178.Load(int4(texCoord * ClusterStride_id182, slice, 0));
    streams.lightIndex_id177 = streams.lightData_id176.x;
}
float3 ComputeSpecularTextureProjection_id55(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id54(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id53(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    int cascadeIndexBase = lightIndex * TCascadeCount_id162;
    int cascadeIndex = 0;

    [unroll]
    for (int i = 0; i < TCascadeCount_id162 - 1; i++)
    {
        [flatten]
        if (streams.DepthVS_id23 > CascadeDepthSplits_id168[cascadeIndexBase + i])
        {
            cascadeIndex = i + 1;
        }
    }
    float3 shadow = 1.0;
    float tempThickness = 999.0;
    float3 shadowPosition = position.xyz;
    shadowPosition += GetShadowPositionOffset_id61(OffsetScales_id161[lightIndex], streams.NdotL_id49, streams.normalWS_id19);
    if (cascadeIndex < TCascadeCount_id162)
    {
        shadow = ComputeShadowFromCascade_id62(shadowPosition, cascadeIndex, lightIndex);
        float nextSplit = CascadeDepthSplits_id168[cascadeIndexBase + cascadeIndex];
        float splitSize = nextSplit;
        if (cascadeIndex > 0)
        {
            splitSize = nextSplit - CascadeDepthSplits_id168[cascadeIndexBase + cascadeIndex - 1];
        }
        float splitDist = (nextSplit - streams.DepthVS_id23) / splitSize;
        if (splitDist < 0.2)
        {
            float lerpAmt = smoothstep(0.0, 0.2, splitDist);
            if (cascadeIndex == TCascadeCount_id162 - 1)
            {
            }
            else if (TBlendCascades_id164)
            {
                float nextShadow = ComputeShadowFromCascade_id62(shadowPosition, cascadeIndex + 1, lightIndex);
                shadow = lerp(nextShadow, shadow, lerpAmt);
            }
        }
    }
    streams.thicknessWS_id85 = tempThickness;
    return shadow;
}
void PrepareDirectLightCore_id52(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id91[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id91[lightIndex].DirectionWS;
}
float3 ComputeSpecularTextureProjection_id49(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id48(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id47(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id46(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id88[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id88[lightIndex].DirectionWS;
}
void ResetStream_id114()
{
}
void AfterLightingAndShading_id195()
{
}
void PrepareEnvironmentLight_id184(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeEnvironmentLightContribution_id188(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor * streams.envLightDiffuseColor_id47;
}
void PrepareEnvironmentLight_id181(inout PS_STREAMS streams)
{
    PrepareEnvironmentLight_id99(streams);
    float3 lightColor = AmbientLight_id185 * streams.matAmbientOcclusion_id57;
    streams.envLightDiffuseColor_id47 = lightColor;
    streams.envLightSpecularColor_id48 = lightColor;
}
void PrepareDirectLight_id172(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id87(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id88(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id89(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id90(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id176(inout PS_STREAMS streams)
{
    return streams.lightData_id176.y >> 16;
}
int GetMaxLightCount_id175(inout PS_STREAMS streams)
{
    return streams.lightData_id176.y >> 16;
}
void PrepareDirectLights_id170()
{
}
void PrepareDirectLight_id159(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id76(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id77(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id78(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id79(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id164(inout PS_STREAMS streams)
{
    return streams.lightData_id176.y & 0xFFFF;
}
int GetMaxLightCount_id163(inout PS_STREAMS streams)
{
    return streams.lightData_id176.y & 0xFFFF;
}
void PrepareDirectLights_id162(inout PS_STREAMS streams)
{
    PrepareLightData_id83(streams);
}
void PrepareDirectLight_id135(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id52(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id53(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id54(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id55(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id137()
{
    return LightCount_id89;
}
int GetMaxLightCount_id138()
{
    return TMaxLightCount_id90;
}
void PrepareDirectLights_id133()
{
}
float3 ComputeDirectLightContribution_id187(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor / PI_id189 * streams.lightColorNdotL_id44 * streams.matDiffuseSpecularAlphaBlend_id65.x;
}
void PrepareMaterialPerDirectLight_id30(inout PS_STREAMS streams)
{
    streams.H_id75 = normalize(streams.viewWS_id68 + streams.lightDirectionWS_id42);
    streams.NdotH_id76 = saturate(dot(streams.normalWS_id19, streams.H_id75));
    streams.LdotH_id77 = saturate(dot(streams.lightDirectionWS_id42, streams.H_id75));
    streams.VdotH_id78 = streams.LdotH_id77;
}
void PrepareDirectLight_id124(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id46(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id47(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id48(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id49(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id126()
{
    return LightCount_id86;
}
int GetMaxLightCount_id127()
{
    return TMaxLightCount_id87;
}
void PrepareDirectLights_id122()
{
}
void PrepareForLightingAndShading_id192()
{
}
void PrepareMaterialForLightingAndShading_id113(inout PS_STREAMS streams)
{
    streams.lightDirectAmbientOcclusion_id50 = lerp(1.0, streams.matAmbientOcclusion_id57, streams.matAmbientOcclusionDirectLightingFactor_id58);
    streams.matDiffuseVisible_id69 = streams.matDiffuse_id53.rgb * lerp(1.0f, streams.matCavity_id59, streams.matCavityDiffuse_id60) * streams.matDiffuseSpecularAlphaBlend_id65.r * streams.matAlphaBlendColor_id66;
    streams.matSpecularVisible_id71 = streams.matSpecular_id55.rgb * streams.matSpecularIntensity_id56 * lerp(1.0f, streams.matCavity_id59, streams.matCavitySpecular_id61) * streams.matDiffuseSpecularAlphaBlend_id65.g * streams.matAlphaBlendColor_id66;
    streams.NdotV_id72 = max(dot(streams.normalWS_id19, streams.viewWS_id68), 0.0001f);
    float roughness = 1.0f - streams.matGlossiness_id54;
    streams.alphaRoughness_id70 = max(roughness * roughness, 0.001);
}
void ResetLightStream_id112(inout PS_STREAMS streams)
{
    streams.lightPositionWS_id41 = 0;
    streams.lightDirectionWS_id42 = 0;
    streams.lightColor_id43 = 0;
    streams.lightColorNdotL_id44 = 0;
    streams.lightSpecularColorNdotL_id45 = 0;
    streams.lightAttenuation_id46 = 1.0f;
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
    streams.lightDirectAmbientOcclusion_id50 = 1.0f;
    streams.NdotL_id49 = 0;
}
void UpdateNormalFromTangentSpace_id23(float3 normalInTangentSpace)
{
}
float4 Compute_id185()
{
    return constantColor_id186;
}
void ResetStream_id115(inout PS_STREAMS streams)
{
    ResetStream_id114();
    streams.matBlend_id40 = 0.0f;
}
void Compute_id229(inout PS_STREAMS streams)
{
    UpdateNormalFromTangentSpace_id23(streams.matNormal_id51);
    if (!streams.IsFrontFace_id1)
        streams.normalWS_id19 = -streams.normalWS_id19;
    ResetLightStream_id112(streams);
    PrepareMaterialForLightingAndShading_id113(streams);

    {
        PrepareForLightingAndShading_id192();
    }
    float3 directLightingContribution = 0;

    {
        PrepareDirectLights_id122();
        const int maxLightCount = GetMaxLightCount_id127();
        int count = GetLightCount_id126();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id124(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id187(streams);
            }
        }
    }

    {
        PrepareDirectLights_id133();
        const int maxLightCount = GetMaxLightCount_id138();
        int count = GetLightCount_id137();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id135(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id187(streams);
            }
        }
    }

    {
        PrepareDirectLights_id162(streams);
        const int maxLightCount = GetMaxLightCount_id163(streams);
        int count = GetLightCount_id164(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id159(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id187(streams);
            }
        }
    }

    {
        PrepareDirectLights_id170();
        const int maxLightCount = GetMaxLightCount_id175(streams);
        int count = GetLightCount_id176(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id172(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id187(streams);
            }
        }
    }
    float3 environmentLightingContribution = 0;

    {
        PrepareEnvironmentLight_id181(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id188(streams);
        }
    }

    {
        PrepareEnvironmentLight_id184(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id188(streams);
        }
    }
    streams.shadingColor_id73 += directLightingContribution * PI_id189 + environmentLightingContribution;
    streams.shadingColorAlpha_id74 = streams.matDiffuse_id53.a;

    {
        AfterLightingAndShading_id195();
    }
}
void Compute_id213(inout PS_STREAMS streams)
{
    float4 colorBase = Compute_id185();
    streams.matDiffuse_id53 = colorBase;
    streams.matColorBase_id52 = colorBase;
}
void ResetStream_id116(inout PS_STREAMS streams)
{
    ResetStream_id115(streams);
    streams.matNormal_id51 = float3(0, 0, 1);
    streams.matColorBase_id52 = 0.0f;
    streams.matDiffuse_id53 = 0.0f;
    streams.matDiffuseVisible_id69 = 0.0f;
    streams.matSpecular_id55 = 0.0f;
    streams.matSpecularVisible_id71 = 0.0f;
    streams.matSpecularIntensity_id56 = 1.0f;
    streams.matGlossiness_id54 = 0.0f;
    streams.alphaRoughness_id70 = 1.0f;
    streams.matAmbientOcclusion_id57 = 1.0f;
    streams.matAmbientOcclusionDirectLightingFactor_id58 = 0.0f;
    streams.matCavity_id59 = 1.0f;
    streams.matCavityDiffuse_id60 = 0.0f;
    streams.matCavitySpecular_id61 = 0.0f;
    streams.matEmissive_id62 = 0.0f;
    streams.matEmissiveIntensity_id63 = 0.0f;
    streams.matScatteringStrength_id64 = 1.0f;
    streams.matDiffuseSpecularAlphaBlend_id65 = 1.0f;
    streams.matAlphaBlendColor_id66 = 1.0f;
    streams.matAlphaDiscard_id67 = 0.1f;
}
float4 ComputeShadingPosition_id11(float4 world)
{
    return mul(world, ViewProjection_id29);
}
void PostTransformPosition_id6()
{
}
void PreTransformPosition_id4()
{
}
void Compute_id43(inout PS_STREAMS streams)
{

    {
        Compute_id213(streams);
    }

    {
        Compute_id229(streams);
    }
}
void ResetStream_id42(inout PS_STREAMS streams)
{
    ResetStream_id116(streams);
    streams.shadingColorAlpha_id74 = 1.0f;
}
void PostTransformPosition_id12(inout VS_STREAMS streams)
{
    PostTransformPosition_id6();
    streams.ShadingPosition_id0 = ComputeShadingPosition_id11(streams.PositionWS_id22);
    streams.PositionH_id24 = streams.ShadingPosition_id0;
    streams.DepthVS_id23 = streams.ShadingPosition_id0.w;
}
void TransformPosition_id5()
{
}
void PreTransformPosition_id10(inout VS_STREAMS streams)
{
    PreTransformPosition_id4();
    streams.PositionWS_id22 = mul(streams.Position_id21, World_id32);
}
float4 Compute_id41()
{
    return MaterialIndex_id83;
}
float4 Shading_id31(inout PS_STREAMS streams)
{
    streams.viewWS_id68 = normalize(Eye_id31.xyz - streams.PositionWS_id22.xyz);
    streams.shadingColor_id73 = 0;
    ResetStream_id42(streams);
    Compute_id43(streams);
    return float4(streams.shadingColor_id73, streams.shadingColorAlpha_id74);
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
    streams.ColorTarget_id2 = Shading_id31(streams);
    streams.ColorTarget1_id3 = Compute_id41();
}
void GenerateNormal_PS_id22(inout PS_STREAMS streams)
{
    if (dot(streams.normalWS_id19, streams.normalWS_id19) > 0)
        streams.normalWS_id19 = normalize(streams.normalWS_id19);
    streams.meshNormalWS_id17 = streams.normalWS_id19;
}
void GenerateNormal_VS_id21(inout VS_STREAMS streams)
{
    streams.meshNormalWS_id17 = mul(streams.meshNormal_id16, (float3x3)WorldInverseTranspose_id34);
    streams.normalWS_id19 = streams.meshNormalWS_id17;
}
void VSMain_id9(inout VS_STREAMS streams)
{
    VSMain_id0();
    BaseTransformVS_id8(streams);
}
void PSMain_id20(inout PS_STREAMS streams)
{
    GenerateNormal_PS_id22(streams);
    PSMain_id3(streams);
}
void VSMain_id19(inout VS_STREAMS streams)
{
    VSMain_id9(streams);
    GenerateNormal_VS_id21(streams);
}
PS_OUTPUT PSMain(PS_INPUT __input__)
{
    PS_STREAMS streams = (PS_STREAMS)0;
    streams.PositionWS_id22 = __input__.PositionWS_id22;
    streams.ShadingPosition_id0 = __input__.ShadingPosition_id0;
    streams.DepthVS_id23 = __input__.DepthVS_id23;
    streams.normalWS_id19 = __input__.normalWS_id19;
    streams.ScreenPosition_id170 = __input__.ScreenPosition_id170;
    streams.IsFrontFace_id1 = __input__.IsFrontFace_id1;
    streams.ScreenPosition_id170 /= streams.ScreenPosition_id170.w;
    PSMain_id20(streams);
    PS_OUTPUT __output__ = (PS_OUTPUT)0;
    __output__.ColorTarget_id2 = streams.ColorTarget_id2;
    __output__.ColorTarget1_id3 = streams.ColorTarget1_id3;
    return __output__;
}
VS_OUTPUT VSMain(VS_INPUT __input__)
{
    VS_STREAMS streams = (VS_STREAMS)0;
    streams.Position_id21 = __input__.Position_id21;
    streams.meshNormal_id16 = __input__.meshNormal_id16;
    VSMain_id19(streams);
    streams.ScreenPosition_id170 = streams.ShadingPosition_id0;
    VS_OUTPUT __output__ = (VS_OUTPUT)0;
    __output__.PositionWS_id22 = streams.PositionWS_id22;
    __output__.ShadingPosition_id0 = streams.ShadingPosition_id0;
    __output__.DepthVS_id23 = streams.DepthVS_id23;
    __output__.normalWS_id19 = streams.normalWS_id19;
    __output__.ScreenPosition_id170 = streams.ScreenPosition_id170;
    return __output__;
}
