/**************************
***** Compiler Parameters *****
***************************
@P EffectName: StrideForwardShadingEffect
@P   - Material.PixelStageSurfaceShaders: mixin MaterialSurfaceArray [{layers = [mixin MaterialSurfaceDiffuse [{diffuseMap = ComputeColorConstantColorLink<Material.DiffuseValue>}], mixin MaterialSurfaceLightingAndShading [{surfaces = [MaterialSurfaceShadingDiffuseLambert<false>]}]]}]
@P Material.PixelStageStreamInitializer: mixin MaterialStream, MaterialPixelShadingStream
@P Lighting.DirectLightGroups: mixin LightDirectionalGroup<2>, ShadowMapReceiverDirectional<4,2,true,true,false,false>, ShadowMapFilterDefault<PerView.Lighting>, LightClusteredPointGroup, LightClusteredSpotGroup
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
@C    constantColor_id182 => Material.DiffuseValue
cbuffer PerView [Size: 2400]
@C    View_id25 => Transformation.View
@C    ViewInverse_id26 => Transformation.ViewInverse
@C    Projection_id27 => Transformation.Projection
@C    ProjectionInverse_id28 => Transformation.ProjectionInverse
@C    ViewProjection_id29 => Transformation.ViewProjection
@C    ProjScreenRay_id30 => Transformation.ProjScreenRay
@C    Eye_id31 => Transformation.Eye
@C    NearClipPlane_id167 => Camera.NearClipPlane
@C    FarClipPlane_id168 => Camera.FarClipPlane
@C    ZProjection_id169 => Camera.ZProjection
@C    ViewSize_id170 => Camera.ViewSize
@C    AspectRatio_id171 => Camera.AspectRatio
@C    _padding_PerView_Default => _padding_PerView_Default
@C    LightCount_id86 => DirectLightGroupPerView.LightCount.directLightGroups[0]
@C    Lights_id88 => LightDirectionalGroup.Lights.directLightGroups[0]
@C    ShadowMapTextureSize_id90 => ShadowMap.TextureSize.directLightGroups[0]
@C    ShadowMapTextureTexelSize_id91 => ShadowMap.TextureTexelSize.directLightGroups[0]
@C    WorldToShadowCascadeUV_id153 => ShadowMapReceiverBase.WorldToShadowCascadeUV.directLightGroups[0]
@C    InverseWorldToShadowCascadeUV_id154 => ShadowMapReceiverBase.InverseWorldToShadowCascadeUV.directLightGroups[0]
@C    ViewMatrices_id155 => ShadowMapReceiverBase.ViewMatrices.directLightGroups[0]
@C    DepthRanges_id156 => ShadowMapReceiverBase.DepthRanges.directLightGroups[0]
@C    DepthBiases_id157 => ShadowMapReceiverBase.DepthBiases.directLightGroups[0]
@C    OffsetScales_id158 => ShadowMapReceiverBase.OffsetScales.directLightGroups[0]
@C    CascadeDepthSplits_id165 => ShadowMapReceiverDirectional.CascadeDepthSplits.directLightGroups[0]
@C    ClusterDepthScale_id176 => LightClustered.ClusterDepthScale
@C    ClusterDepthBias_id177 => LightClustered.ClusterDepthBias
@C    ClusterStride_id178 => LightClustered.ClusterStride
@C    AmbientLight_id181 => LightSimpleAmbient.AmbientLight.environmentLights[0]
@C    _padding_PerView_Lighting => _padding_PerView_Lighting
***************************
******  Resources    ******
***************************
@R    PerMaterial => PerMaterial [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: None, Slot: (-1--1)]
@R    LightClusters_id174 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightClusters_id174 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightIndices_id175 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    LightIndices_id175 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    PointLights_id179 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    PointLights_id179 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id180 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id180 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    PerDraw => PerDraw [Stage: Vertex, Slot: (0-0)]
@R    PerView => PerView [Stage: Vertex, Slot: (1-1)]
@R    LinearClampCompareLessEqualSampler_id124 => Texturing.LinearClampCompareLessEqualSampler [Stage: Pixel, Slot: (0-0)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: Pixel, Slot: (0-0)]
@R    LightClusters_id174 => LightClustered.LightClusters [Stage: Pixel, Slot: (1-1)]
@R    LightIndices_id175 => LightClustered.LightIndices [Stage: Pixel, Slot: (2-2)]
@R    PointLights_id179 => LightClusteredPointGroup.PointLights [Stage: Pixel, Slot: (3-3)]
@R    SpotLights_id180 => LightClusteredSpotGroup.SpotLights [Stage: Pixel, Slot: (4-4)]
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
@S    GBufferOutputSubsurfaceScatteringMaterialIndex => 5df9471bf02401dc5db0de4bbd3d8abb
***************************
*****     Stages      *****
***************************
@G    Vertex => c6648e19c518a071743e8afd835f44e3
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
//   float NearClipPlane_id167;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id168;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id169;          // Offset:  360 Size:     8 [unused]
//   float2 ViewSize_id170;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id171;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[2];                  // Offset:  416 Size:    60 [unused]
//   float2 ShadowMapTextureSize_id90;  // Offset:  480 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id91;// Offset:  488 Size:     8 [unused]
//   float4x4 WorldToShadowCascadeUV_id153[8];// Offset:  496 Size:   512 [unused]
//   float4x4 InverseWorldToShadowCascadeUV_id154[8];// Offset: 1008 Size:   512 [unused]
//   float4x4 ViewMatrices_id155[8];    // Offset: 1520 Size:   512 [unused]
//   float2 DepthRanges_id156[8];       // Offset: 2032 Size:   120 [unused]
//   float DepthBiases_id157[2];        // Offset: 2160 Size:    20 [unused]
//   float OffsetScales_id158[2];       // Offset: 2192 Size:    20 [unused]
//   float CascadeDepthSplits_id165[8]; // Offset: 2224 Size:   116 [unused]
//   float ClusterDepthScale_id176;     // Offset: 2340 Size:     4 [unused]
//   float ClusterDepthBias_id177;      // Offset: 2344 Size:     4 [unused]
//   float2 ClusterStride_id178;        // Offset: 2352 Size:     8 [unused]
//   float3 AmbientLight_id181;         // Offset: 2368 Size:    12 [unused]
//   float4 _padding_PerView_Lighting;  // Offset: 2384 Size:    16 [unused]
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
// SCREENPOSITION_ID166_SEM     0   xyzw        3     NONE   float   xyzw
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
//   o3.x <- <VSMain return value>.ScreenPosition_id166.x; o3.y <- <VSMain return value>.ScreenPosition_id166.y; o3.z <- <VSMain return value>.ScreenPosition_id166.z; o3.w <- <VSMain return value>.ScreenPosition_id166.w; 
//   o2.x <- <VSMain return value>.DepthVS_id23; o2.y <- <VSMain return value>.normalWS_id19.x; o2.z <- <VSMain return value>.normalWS_id19.y; o2.w <- <VSMain return value>.normalWS_id19.z; 
//   o1.x <- <VSMain return value>.ShadingPosition_id0.x; o1.y <- <VSMain return value>.ShadingPosition_id0.y; o1.z <- <VSMain return value>.ShadingPosition_id0.z; o1.w <- <VSMain return value>.ShadingPosition_id0.w; 
//   o0.x <- <VSMain return value>.PositionWS_id22.x; o0.y <- <VSMain return value>.PositionWS_id22.y; o0.z <- <VSMain return value>.PositionWS_id22.z; o0.w <- <VSMain return value>.PositionWS_id22.w
//
#line 857 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_cb76c5abe80cc48cb029d5c037e5f4fb.hlsl"
dp4 r0.x, v0.xyzw, cb0[0].xyzw  // r0.x <- streams.PositionWS_id22.x
dp4 r0.y, v0.xyzw, cb0[1].xyzw  // r0.y <- streams.PositionWS_id22.y
dp4 r0.z, v0.xyzw, cb0[2].xyzw  // r0.z <- streams.PositionWS_id22.z
dp4 r0.w, v0.xyzw, cb0[3].xyzw  // r0.w <- streams.PositionWS_id22.w

#line 944
mov o0.xyzw, r0.xyzw

#line 820
dp4 r1.x, r0.xyzw, cb1[16].xyzw  // r1.x <- <ComputeShadingPosition_id11 return value>.x
dp4 r1.y, r0.xyzw, cb1[17].xyzw  // r1.y <- <ComputeShadingPosition_id11 return value>.y
dp4 r1.z, r0.xyzw, cb1[18].xyzw  // r1.z <- <ComputeShadingPosition_id11 return value>.z
dp4 r1.w, r0.xyzw, cb1[19].xyzw  // r1.w <- <ComputeShadingPosition_id11 return value>.w

#line 944
mov o1.xyzw, r1.xyzw
mov o3.xyzw, r1.xyzw
mov o2.x, r1.w

#line 897
dp3 o2.y, v1.xyzx, cb0[8].xyzx
dp3 o2.z, v1.xyzx, cb0[9].xyzx
dp3 o2.w, v1.xyzx, cb0[10].xyzx

#line 944
ret 
// Approximately 16 instruction slots used
@G    Pixel => f7fc7c99b86f6a4c2874636b466bfa91
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
//   float4 constantColor_id182;        // Offset:    0 Size:    16
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
//   float NearClipPlane_id167;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id168;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id169;          // Offset:  360 Size:     8
//   float2 ViewSize_id170;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id171;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88[2];                  // Offset:  416 Size:    60
//   float2 ShadowMapTextureSize_id90;  // Offset:  480 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id91;// Offset:  488 Size:     8
//   float4x4 WorldToShadowCascadeUV_id153[8];// Offset:  496 Size:   512
//   float4x4 InverseWorldToShadowCascadeUV_id154[8];// Offset: 1008 Size:   512 [unused]
//   float4x4 ViewMatrices_id155[8];    // Offset: 1520 Size:   512 [unused]
//   float2 DepthRanges_id156[8];       // Offset: 2032 Size:   120 [unused]
//   float DepthBiases_id157[2];        // Offset: 2160 Size:    20
//   float OffsetScales_id158[2];       // Offset: 2192 Size:    20
//   float CascadeDepthSplits_id165[8]; // Offset: 2224 Size:   116
//   float ClusterDepthScale_id176;     // Offset: 2340 Size:     4
//   float ClusterDepthBias_id177;      // Offset: 2344 Size:     4
//   float2 ClusterStride_id178;        // Offset: 2352 Size:     8
//   float3 AmbientLight_id181;         // Offset: 2368 Size:    12
//   float4 _padding_PerView_Lighting;  // Offset: 2384 Size:    16 [unused]
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- -------------- ------
// LinearClampCompareLessEqualSampler_id124  sampler_c      NA          NA             s0      1 
// ShadowMapTexture_id89             texture  float4          2d             t0      1 
// LightClusters_id174               texture   uint2          3d             t1      1 
// LightIndices_id175                texture    uint         buf             t2      1 
// PointLights_id179                 texture  float4         buf             t3      1 
// SpotLights_id180                  texture  float4         buf             t4      1 
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
// SCREENPOSITION_ID166_SEM     0   xyzw        3     NONE   float   xy w
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
dcl_constantbuffer CB2[149], dynamicIndexed
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
dcl_temps 10
//
// Initial variable locations:
//   v0.x <- __input__.PositionWS_id22.x; v0.y <- __input__.PositionWS_id22.y; v0.z <- __input__.PositionWS_id22.z; v0.w <- __input__.PositionWS_id22.w; 
//   v1.x <- __input__.ShadingPosition_id0.x; v1.y <- __input__.ShadingPosition_id0.y; v1.z <- __input__.ShadingPosition_id0.z; v1.w <- __input__.ShadingPosition_id0.w; 
//   v2.x <- __input__.DepthVS_id23; v2.y <- __input__.normalWS_id19.x; v2.z <- __input__.normalWS_id19.y; v2.w <- __input__.normalWS_id19.z; 
//   v3.x <- __input__.ScreenPosition_id166.x; v3.y <- __input__.ScreenPosition_id166.y; v3.z <- __input__.ScreenPosition_id166.z; v3.w <- __input__.ScreenPosition_id166.w; 
//   v4.x <- __input__.IsFrontFace_id1; 
//   o1.x <- <PSMain return value>.ColorTarget1_id3.x; o1.y <- <PSMain return value>.ColorTarget1_id3.y; o1.z <- <PSMain return value>.ColorTarget1_id3.z; o1.w <- <PSMain return value>.ColorTarget1_id3.w; 
//   o0.x <- <PSMain return value>.ColorTarget_id2.x; o0.y <- <PSMain return value>.ColorTarget_id2.y; o0.z <- <PSMain return value>.ColorTarget_id2.z; o0.w <- <PSMain return value>.ColorTarget_id2.w
//
#line 924 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_cb76c5abe80cc48cb029d5c037e5f4fb.hlsl"
div r0.xy, v3.xyxx, v3.wwww  // r0.x <- streams.ScreenPosition_id166.x; r0.y <- streams.ScreenPosition_id166.y

#line 891
dp3 r0.z, v2.yzwy, v2.yzwy
lt r0.w, l(0.000000), r0.z

#line 892
rsq r0.z, r0.z
mul r1.xyz, r0.zzzz, v2.yzwy  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z
movc r1.xyz, r0.wwww, r1.xyzx, v2.yzwy

#line 696
movc r1.xyz, v4.xxxx, r1.xyzx, -r1.xyzx  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z

#line 427
add r0.z, cb2[30].z, cb2[30].z

#line 419
mov r2.w, l(1.000000)

#line 710
mov r3.xyz, r1.xyzx  // r3.x <- streams.normalWS_id19.x; r3.y <- streams.normalWS_id19.y; r3.z <- streams.normalWS_id19.z
mov r3.w, v0.x  // r3.w <- streams.PositionWS_id22.x
mov r4.yz, v0.yyzy  // r4.y <- streams.PositionWS_id22.y; r4.z <- streams.PositionWS_id22.z
mov r5.xyz, cb1[0].xyzx  // r5.x <- streams.matDiffuseVisible_id69.x; r5.y <- streams.matDiffuseVisible_id69.y; r5.z <- streams.matDiffuseVisible_id69.z
mov r6.xyz, l(0,0,0,0)  // r6.x <- directLightingContribution.x; r6.y <- directLightingContribution.y; r6.z <- directLightingContribution.z
mov r0.w, v2.x  // r0.w <- streams.DepthVS_id23
mov r1.w, l(0)  // r1.w <- i
loop 
  ige r4.w, r1.w, l(2)
  breakc_nz r4.w

#line 712
  ige r4.w, r1.w, cb2[25].x
  if_nz r4.w

#line 714
    break 

#line 715
  endif 

#line 506
  ishl r7.xy, r1.wwww, l(1, 2, 0, 0)  // r7.y <- cascadeIndexBase

#line 636
  dp3 r4.w, r3.xyzx, -cb2[r7.x + 26].xyzx
  max r4.w, r4.w, l(0.000100)  // r4.w <- streams.NdotL_id49

#line 513
  lt r5.w, cb2[r7.y + 139].x, r0.w

#line 516
  and r5.w, r5.w, l(1)  // r5.w <- cascadeIndex

#line 513
  bfi r7.zw, l(0, 0, 30, 30), l(0, 0, 2, 2), r1.wwww, l(0, 0, 1, 2)
  lt r6.w, cb2[r7.z + 139].x, r0.w

#line 516
  movc r5.w, r6.w, l(2), r5.w

#line 513
  lt r6.w, cb2[r7.w + 139].x, r0.w

#line 516
  movc r5.w, r6.w, l(3), r5.w

#line 426
  add r7.z, -r4.w, l(1.000000)
  max r7.z, r7.z, l(0.000000)  // r7.z <- normalOffsetScale

#line 427
  mul r7.w, r0.z, cb2[r1.w + 137].x
  mul r7.z, r7.z, r7.w

#line 521
  mov r4.x, r3.w
  mad r2.xyz, r7.zzzz, r3.xyzx, r4.xyzx  // r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z

#line 419
  bfi r4.x, l(30), l(2), r1.w, r5.w
  ishl r7.z, r5.w, l(2)
  bfi r7.z, l(30), l(4), r1.w, r7.z
  dp4 r8.x, r2.xyzw, cb2[r7.z + 31].xyzw  // r8.x <- shadowPosition.x
  dp4 r8.y, r2.xyzw, cb2[r7.z + 32].xyzw  // r8.y <- shadowPosition.y
  dp4 r7.w, r2.xyzw, cb2[r7.z + 33].xyzw  // r7.w <- shadowPosition.z
  dp4 r7.z, r2.xyzw, cb2[r7.z + 34].xyzw  // r7.z <- shadowPosition.w

#line 420
  add r8.z, r7.w, -cb2[r1.w + 135].x  // r8.z <- shadowPosition.z

#line 421
  div r8.xyz, r8.xyzx, r7.zzzz

#line 393
  sample_c_lz_indexable(texture2d)(float,float,float,float) r7.z, r8.xyxx, t0.xxxx, s0, r8.z  // r7.z <- <FilterShadow_id53 return value>

#line 527
  ilt r7.w, l(0), r5.w
  if_nz r7.w

#line 529
    iadd r7.w, r4.x, l(-1)
    add r7.w, -cb2[r7.w + 139].x, cb2[r4.x + 139].x  // r7.w <- splitSize

#line 530
  else 
    mov r7.w, cb2[r4.x + 139].x  // r7.w <- splitSize
  endif 

#line 531
  add r4.x, -r0.w, cb2[r4.x + 139].x
  div r4.x, r4.x, r7.w  // r4.x <- splitDist

#line 532
  lt r7.w, r4.x, l(0.200000)
  if_nz r7.w

#line 535
    if_nz r6.w

#line 537
      mov r8.xyz, r7.zzzz  // r8.x <- shadow.x; r8.y <- shadow.y; r8.z <- shadow.z
    else 

#line 534
      mul_sat r4.x, r4.x, l(5.000000)
      mad r6.w, r4.x, l(-2.000000), l(3.000000)
      mul r4.x, r4.x, r4.x
      mul r4.x, r4.x, r6.w  // r4.x <- lerpAmt

#line 419
      ishl r6.w, r7.y, l(2)
      imad r5.w, r5.w, l(4), r6.w
      iadd r5.w, r5.w, l(4)
      dp4 r9.x, r2.xyzw, cb2[r5.w + 31].xyzw  // r9.x <- shadowPosition.x
      dp4 r9.y, r2.xyzw, cb2[r5.w + 32].xyzw  // r9.y <- shadowPosition.y
      dp4 r6.w, r2.xyzw, cb2[r5.w + 33].xyzw  // r6.w <- shadowPosition.z
      dp4 r2.x, r2.xyzw, cb2[r5.w + 34].xyzw  // r2.x <- shadowPosition.w

#line 420
      add r9.z, r6.w, -cb2[r1.w + 135].x  // r9.z <- shadowPosition.z

#line 421
      div r2.xyz, r9.xyzx, r2.xxxx  // r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z

#line 393
      sample_c_lz_indexable(texture2d)(float,float,float,float) r2.x, r2.xyxx, t0.xxxx, s0, r2.z  // r2.x <- <FilterShadow_id53 return value>

#line 541
      add r2.y, -r2.x, r7.z
      mad r8.xyz, r4.xxxx, r2.yyyy, r2.xxxx  // r8.x <- shadow.x; r8.y <- shadow.y; r8.z <- shadow.z

#line 542
    endif 

#line 543
  else   // Prior locations: r5.w <- cascadeIndex; r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z; r4.x <- splitDist
    mov r8.xyz, r7.zzzz  // r8.x <- shadow.x; r8.y <- shadow.y; r8.z <- shadow.z
  endif 

#line 638
  mul r2.xyz, r8.xyzx, cb2[r7.x + 27].xyzx
  mul r2.xyz, r4.wwww, r2.xyzx  // r2.x <- streams.lightColorNdotL_id44.x; r2.y <- streams.lightColorNdotL_id44.y; r2.z <- streams.lightColorNdotL_id44.z

#line 624
  mul r2.xyz, r2.xyzx, r5.xyzx

#line 720
  mad r6.xyz, r2.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r6.xyzx

#line 710
  iadd r1.w, r1.w, l(1)

#line 722
endloop 

#line 490
add r0.z, v1.z, -cb2[22].z
div r0.z, cb2[22].w, r0.z  // r0.z <- depth

#line 491
mad r0.xy, r0.xyxx, l(1.000000, -1.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
mul r0.xy, r0.xyxx, cb2[147].xyxx

#line 492
mad r0.z, r0.z, cb2[146].y, cb2[146].z
log r0.z, r0.z
max r0.z, r0.z, l(0.000000)

#line 493
mul r0.xy, r0.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)

#line 492
ftoi r2.xyz, r0.xyzx  // r2.z <- slice

#line 493
mov r2.w, l(0)
ld_indexable(texture3d)(uint,uint,uint,uint) r0.xy, r2.xyzw, t1.xyzw  // r0.x <- streams.lightData_id172.x; r0.y <- streams.lightData_id172.y

#line 615
and r0.z, r0.y, l(0x0000ffff)  // r0.z <- <GetMaxLightCount_id139 return value>

#line 730
mov r2.xyz, r1.xyzx  // r2.x <- streams.normalWS_id19.x; r2.y <- streams.normalWS_id19.y; r2.z <- streams.normalWS_id19.z
mov r2.w, v0.x  // r2.w <- streams.PositionWS_id22.x
mov r3.yz, v0.yyzy  // r3.y <- streams.PositionWS_id22.y; r3.z <- streams.PositionWS_id22.z
mov r4.xyz, cb1[0].xyzx  // r4.x <- streams.matDiffuseVisible_id69.x; r4.y <- streams.matDiffuseVisible_id69.y; r4.z <- streams.matDiffuseVisible_id69.z
mov r5.xyz, r6.xyzx  // r5.x <- directLightingContribution.x; r5.y <- directLightingContribution.y; r5.z <- directLightingContribution.z
mov r7.x, r0.x  // r7.x <- streams.lightIndex_id173
mov r0.w, l(0)  // r0.w <- i
loop 
  ige r1.w, r0.w, r0.z
  breakc_nz r1.w

#line 732
  if_nz r1.w

#line 734
    break 

#line 735
  endif 

#line 477
  ld_indexable(buffer)(uint,uint,uint,uint) r1.w, r7.xxxx, t2.yzwx  // r1.w <- realLightIndex

#line 478
  iadd r7.x, r7.x, l(1)  // r7.x <- streams.lightIndex_id173

#line 480
  ishl r3.w, r1.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r8.xyzw, r3.wwww, t3.xyzw  // r8.x <- pointLight1.x; r8.y <- pointLight1.y; r8.z <- pointLight1.z; r8.w <- pointLight1.w

#line 481
  bfi r1.w, l(31), l(1), r1.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r7.yzw, r1.wwww, t3.wxyz  // r7.y <- pointLight2.x; r7.z <- pointLight2.y; r7.w <- pointLight2.z

#line 370
  mov r3.x, r2.w
  add r8.xyz, -r3.xyzx, r8.xyzx  // r8.x <- lightVector.x; r8.y <- lightVector.y; r8.z <- lightVector.z

#line 371
  dp3 r1.w, r8.xyzx, r8.xyzx
  sqrt r3.x, r1.w  // r3.x <- lightVectorLength

#line 372
  div r8.xyz, r8.xyzx, r3.xxxx  // r8.x <- lightVectorNorm.x; r8.y <- lightVectorNorm.y; r8.z <- lightVectorNorm.z

#line 316
  max r3.x, r1.w, l(0.000100)
  div r3.x, l(1.000000, 1.000000, 1.000000, 1.000000), r3.x  // r3.x <- attenuation

#line 289
  mul r1.w, r8.w, r1.w  // r1.w <- factor

#line 290
  mad r1.w, -r1.w, r1.w, l(1.000000)
  max r1.w, r1.w, l(0.000000)  // r1.w <- smoothFactor

#line 291
  mul r1.w, r1.w, r1.w  // r1.w <- <SmoothDistanceAttenuation_id67 return value>

#line 317
  mul r1.w, r1.w, r3.x  // r1.w <- attenuation

#line 601
  dp3 r3.x, r2.xyzx, r8.xyzx
  max r3.x, r3.x, l(0.000100)  // r3.x <- streams.NdotL_id49

#line 603
  mul r7.yzw, r1.wwww, r7.yyzw
  mul r7.yzw, r3.xxxx, r7.yyzw  // r7.y <- streams.lightColorNdotL_id44.x; r7.z <- streams.lightColorNdotL_id44.y; r7.w <- streams.lightColorNdotL_id44.z

#line 624
  mul r7.yzw, r7.yyzw, r4.xxyz

#line 740
  mad r5.xyz, r7.yzwy, l(0.318310, 0.318310, 0.318310, 0.000000), r5.xyzx

#line 730
  iadd r0.w, r0.w, l(1)

#line 742
endloop   // r7.x <- streams.lightIndex_id173

#line 593
ushr r0.x, r0.y, l(16)  // r0.x <- <GetMaxLightCount_id151 return value>

#line 750
mov r2.xyz, r1.xyzx
mov r2.w, v0.x
mov r3.yz, v0.yyzy
mov r0.yzw, cb1[0].xxyz  // r0.y <- streams.matDiffuseVisible_id69.x; r0.z <- streams.matDiffuseVisible_id69.y; r0.w <- streams.matDiffuseVisible_id69.z
mov r4.xyz, r5.xyzx  // r4.x <- directLightingContribution.x; r4.y <- directLightingContribution.y; r4.z <- directLightingContribution.z
mov r1.w, r7.x  // r1.w <- streams.lightIndex_id173
mov r3.w, l(0)  // r3.w <- i
loop 
  ige r4.w, r3.w, r0.x
  breakc_nz r4.w

#line 752
  if_nz r4.w

#line 754
    break 

#line 755
  endif 

#line 449
  ld_indexable(buffer)(uint,uint,uint,uint) r4.w, r1.wwww, t2.yzwx  // r4.w <- realLightIndex

#line 450
  iadd r1.w, r1.w, l(1)  // r1.w <- streams.lightIndex_id173

#line 452
  ishl r5.w, r4.w, l(2)
  ld_indexable(buffer)(float,float,float,float) r6.xyz, r5.wwww, t4.xyzw  // r6.x <- spotLight1.x; r6.y <- spotLight1.y; r6.z <- spotLight1.z

#line 455
  bfi r7.yzw, l(0, 30, 30, 30), l(0, 2, 2, 2), r4.wwww, l(0, 1, 2, 3)

#line 453
  ld_indexable(buffer)(float,float,float,float) r8.xyz, r7.yyyy, t4.xyzw  // r8.x <- spotLight2.x; r8.y <- spotLight2.y; r8.z <- spotLight2.z

#line 454
  ld_indexable(buffer)(float,float,float,float) r9.xyz, r7.zzzz, t4.xyzw  // r9.x <- spotLight3.x; r9.y <- spotLight3.y; r9.z <- spotLight3.z

#line 455
  ld_indexable(buffer)(float,float,float,float) r7.yzw, r7.wwww, t4.wxyz  // r7.y <- spotLight4.x; r7.z <- spotLight4.y; r7.w <- spotLight4.z

#line 357
  mov r3.x, r2.w
  add r6.xyz, -r3.xyzx, r6.xyzx  // r6.x <- lightVector.x; r6.y <- lightVector.y; r6.z <- lightVector.z

#line 358
  dp3 r3.x, r6.xyzx, r6.xyzx
  sqrt r4.w, r3.x  // r4.w <- lightVectorLength

#line 359
  div r6.xyz, r6.xyzx, r4.wwww  // r6.x <- lightVectorNorm.x; r6.y <- lightVectorNorm.y; r6.z <- lightVectorNorm.z

#line 309
  max r4.w, r3.x, l(0.000100)
  div r4.w, l(1.000000, 1.000000, 1.000000, 1.000000), r4.w  // r4.w <- attenuation

#line 283
  mul r3.x, r9.z, r3.x  // r3.x <- factor

#line 284
  mad r3.x, -r3.x, r3.x, l(1.000000)
  max r3.x, r3.x, l(0.000000)  // r3.x <- smoothFactor

#line 285
  mul r3.x, r3.x, r3.x  // r3.x <- <SmoothDistanceAttenuation_id78 return value>

#line 310
  mul r3.x, r3.x, r4.w  // r3.x <- attenuation

#line 301
  dp3 r4.w, -r8.xyzx, r6.xyzx  // r4.w <- cd

#line 302
  mad_sat r4.w, r4.w, r9.x, r9.y  // r4.w <- attenuation

#line 303
  mul r4.w, r4.w, r4.w

#line 365
  mul r3.x, r3.x, r4.w  // r3.x <- attenuation

#line 579
  dp3 r4.w, r2.xyzx, r6.xyzx
  max r4.w, r4.w, l(0.000100)  // r4.w <- streams.NdotL_id49

#line 581
  mul r6.xyz, r3.xxxx, r7.yzwy
  mul r6.xyz, r4.wwww, r6.xyzx  // r6.x <- streams.lightColorNdotL_id44.x; r6.y <- streams.lightColorNdotL_id44.y; r6.z <- streams.lightColorNdotL_id44.z

#line 624
  mul r6.xyz, r0.yzwy, r6.xyzx

#line 760
  mad r4.xyz, r6.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r4.xyzx

#line 750
  iadd r3.w, r3.w, l(1)

#line 762
endloop   // r1.w <- streams.lightIndex_id173

#line 567
mul r0.xyz, cb1[0].xyzx, cb2[148].xyzx  // r0.x <- <ComputeEnvironmentLightContribution_id164 return value>.x; r0.y <- <ComputeEnvironmentLightContribution_id164 return value>.y; r0.z <- <ComputeEnvironmentLightContribution_id164 return value>.z

#line 781
mad o0.xyz, r4.xyzx, l(3.141593, 3.141593, 3.141593, 0.000000), r0.xyzx

#line 861
utof o1.xyzw, cb0[26].xxxx

#line 929
mov o0.w, cb1[0].w
ret 
// Approximately 191 instruction slots used
***************************
*************************/
const static int TMaxLightCount_id87 = 2;
const static int TCascadeCountBase_id151 = 4;
const static int TLightCountBase_id152 = 2;
const static int TCascadeCount_id159 = 4;
const static int TLightCount_id160 = 2;
const static bool TBlendCascades_id161 = true;
const static bool TDepthRangeAuto_id162 = true;
const static bool TCascadeDebug_id163 = false;
const static bool TComputeTransmittance_id164 = false;
static const float PI_id185 = 3.14159265358979323846;
const static bool TIsEnergyConservative_id186 = false;
struct PS_STREAMS 
{
    float4 ScreenPosition_id166;
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
    uint2 lightData_id172;
    int lightIndex_id173;
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
    float4 ScreenPosition_id166 : SCREENPOSITION_ID166_SEM;
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
    float4 ScreenPosition_id166;
};
struct VS_OUTPUT 
{
    float4 PositionWS_id22 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float DepthVS_id23 : DEPTH_VS;
    float3 normalWS_id19 : NORMALWS;
    float4 ScreenPosition_id166 : SCREENPOSITION_ID166_SEM;
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
    float4 constantColor_id182;
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
    float NearClipPlane_id167 = 1.0f;
    float FarClipPlane_id168 = 100.0f;
    float2 ZProjection_id169;
    float2 ViewSize_id170;
    float AspectRatio_id171;
    float4 _padding_PerView_Default;
    int LightCount_id86;
    DirectionalLightData Lights_id88[TMaxLightCount_id87];
    float2 ShadowMapTextureSize_id90;
    float2 ShadowMapTextureTexelSize_id91;
    float4x4 WorldToShadowCascadeUV_id153[TCascadeCountBase_id151 * TLightCountBase_id152];
    float4x4 InverseWorldToShadowCascadeUV_id154[TCascadeCountBase_id151 * TLightCountBase_id152];
    float4x4 ViewMatrices_id155[TCascadeCountBase_id151 * TLightCountBase_id152];
    float2 DepthRanges_id156[TCascadeCountBase_id151 * TLightCountBase_id152];
    float DepthBiases_id157[TLightCountBase_id152];
    float OffsetScales_id158[TLightCountBase_id152];
    float CascadeDepthSplits_id165[TCascadeCount_id159 * TLightCount_id160];
    float ClusterDepthScale_id176;
    float ClusterDepthBias_id177;
    float2 ClusterStride_id178;
    float3 AmbientLight_id181;
    float4 _padding_PerView_Lighting;
};
cbuffer Globals 
{
    float2 Texture0TexelSize_id93;
    float2 Texture1TexelSize_id95;
    float2 Texture2TexelSize_id97;
    float2 Texture3TexelSize_id99;
    float2 Texture4TexelSize_id101;
    float2 Texture5TexelSize_id103;
    float2 Texture6TexelSize_id105;
    float2 Texture7TexelSize_id107;
    float2 Texture8TexelSize_id109;
    float2 Texture9TexelSize_id111;
};
Texture2D Texture0_id92;
Texture2D Texture1_id94;
Texture2D Texture2_id96;
Texture2D Texture3_id98;
Texture2D Texture4_id100;
Texture2D Texture5_id102;
Texture2D Texture6_id104;
Texture2D Texture7_id106;
Texture2D Texture8_id108;
Texture2D Texture9_id110;
TextureCube TextureCube0_id112;
TextureCube TextureCube1_id113;
TextureCube TextureCube2_id114;
TextureCube TextureCube3_id115;
Texture3D Texture3D0_id116;
Texture3D Texture3D1_id117;
Texture3D Texture3D2_id118;
Texture3D Texture3D3_id119;
SamplerState Sampler_id120;
SamplerState PointSampler_id121 
{
    Filter = MIN_MAG_MIP_POINT;
};
SamplerState LinearSampler_id122 
{
    Filter = MIN_MAG_MIP_LINEAR;
};
SamplerState LinearBorderSampler_id123 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Border;
    AddressV = Border;
};
SamplerComparisonState LinearClampCompareLessEqualSampler_id124 
{
    Filter = COMPARISON_MIN_MAG_LINEAR_MIP_POINT;
    AddressU = Clamp;
    AddressV = Clamp;
    ComparisonFunc = LessEqual;
};
SamplerState AnisotropicSampler_id125 
{
    Filter = ANISOTROPIC;
};
SamplerState AnisotropicRepeatSampler_id126 
{
    Filter = ANISOTROPIC;
    AddressU = Wrap;
    AddressV = Wrap;
    MaxAnisotropy = 16;
};
SamplerState PointRepeatSampler_id127 
{
    Filter = MIN_MAG_MIP_POINT;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState LinearRepeatSampler_id128 
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState RepeatSampler_id129 
{
    AddressU = Wrap;
    AddressV = Wrap;
};
SamplerState Sampler0_id130;
SamplerState Sampler1_id131;
SamplerState Sampler2_id132;
SamplerState Sampler3_id133;
SamplerState Sampler4_id134;
SamplerState Sampler5_id135;
SamplerState Sampler6_id136;
SamplerState Sampler7_id137;
SamplerState Sampler8_id138;
SamplerState Sampler9_id139;
Texture2D ShadowMapTexture_id89;
Texture3D<uint2> LightClusters_id174;
Buffer<uint> LightIndices_id175;
Buffer<float4> PointLights_id179;
Buffer<float4> SpotLights_id180;
float SmoothDistanceAttenuation_id78(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float SmoothDistanceAttenuation_id67(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float4 Project_id52(float4 vec, float4x4 mat)
{
    float4 vecProjected = mul(vec, mat);
    vecProjected.xyz /= vecProjected.w;
    return vecProjected;
}
float GetAngularAttenuation_id80(float3 lightVector, float3 lightDirection, float lightAngleScale, float lightAngleOffset)
{
    float cd = dot(lightDirection, lightVector);
    float attenuation = saturate(cd * lightAngleScale + lightAngleOffset);
    attenuation *= attenuation;
    return attenuation;
}
float GetDistanceAttenuation_id79(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id78(d2, lightInvSquareRadius);
    return attenuation;
}
float GetDistanceAttenuation_id69(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id67(d2, lightInvSquareRadius);
    return attenuation;
}
float SampleThickness_id60(float3 shadowSpaceCoordinate, float3 pixelPositionWS, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float shadowMapDepth = ShadowMapTexture_id89.SampleLevel(LinearBorderSampler_id123, shadowSpaceCoordinate.xy, 0).r;
    float thickness;
    if (isOrthographic)
    {
        thickness = abs(shadowMapDepth - shadowSpaceCoordinate.z) * depthRanges.y;
    }
    else
    {
        float4 shadowmapPositionWorldSpace = Project_id52(float4(shadowSpaceCoordinate.xy, shadowMapDepth, 1.0), inverseWorldToShadowCascadeUV);
        thickness = distance(shadowmapPositionWorldSpace.xyz, pixelPositionWS.xyz);
    }
    return (thickness);
}
void CalculateAdjustedShadowSpacePixelPosition_id59(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    float4 bottomLeftTexelWS = Project_id52(float4(0.0, 0.0, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id52(float4(ShadowMapTextureTexelSize_id91.xy * filterRadiusInPixels, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, bottomLeftTexelWS.xyz);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 shadowMapCoordinate = Project_id52(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = shadowMapCoordinate.xyz;
}
void CalculateAdjustedShadowSpacePixelPositionPerspective_id58(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    const float4 shadowMapCoordinate = Project_id52(float4(pixelPositionWS, 1.0), worldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id52(float4(shadowMapCoordinate.xy + ShadowMapTextureTexelSize_id91.xy * filterRadiusInPixels, shadowMapCoordinate.z, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, pixelPositionWS);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 adjustedShadowMapCoordinate = Project_id52(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = adjustedShadowMapCoordinate.xyz;
}
float ComputeAttenuation_id81(float3 PositionWS, float3 AngleOffsetAndInvSquareRadius, float3 DirectionWS, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float3 lightAngleOffsetAndInvSquareRadius = AngleOffsetAndInvSquareRadius;
    float2 lightAngleAndOffset = lightAngleOffsetAndInvSquareRadius.xy;
    float lightInvSquareRadius = lightAngleOffsetAndInvSquareRadius.z;
    float3 lightDirection = -DirectionWS;
    float attenuation = GetDistanceAttenuation_id79(lightVectorLength, lightInvSquareRadius);
    attenuation *= GetAngularAttenuation_id80(lightVectorNorm, lightDirection, lightAngleAndOffset.x, lightAngleAndOffset.y);
    return attenuation;
}
float ComputeAttenuation_id68(PointLightDataInternal light, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = light.PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float lightInvSquareRadius = light.InvSquareRadius;
    return GetDistanceAttenuation_id69(lightVectorLength, lightInvSquareRadius);
}
float FilterThickness_id54(float3 pixelPositionWS, float3 meshNormalWS, float2 depthRanges, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float filterRadiusInPixels = 1.5;
    float3 adjustedPixelPositionWS;
    float3 adjustedPixelPositionShadowSpace;
    if (isOrthographic)
    {
        CalculateAdjustedShadowSpacePixelPosition_id59(filterRadiusInPixels, pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    else
    {
        CalculateAdjustedShadowSpacePixelPositionPerspective_id58(filterRadiusInPixels, pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    return SampleThickness_id60(adjustedPixelPositionShadowSpace, adjustedPixelPositionWS, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
}
float FilterShadow_id53(float2 position, float positionDepth)
{
    return ShadowMapTexture_id89.SampleCmpLevelZero(LinearClampCompareLessEqualSampler_id124, position, positionDepth);
}
void ProcessLight_id82(inout PS_STREAMS streams, SpotLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id81(light.PositionWS, light.AngleOffsetAndInvSquareRadius, light.DirectionWS, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
void ProcessLight_id71(inout PS_STREAMS streams, PointLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id68(light, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightPositionWS_id41 = light.PositionWS;
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
float ComputeThicknessFromCascade_id57(float3 pixelPositionWS, float3 meshNormalWS, int cascadeIndex, int lightIndex, bool isOrthographic)
{
    const int arrayIndex = cascadeIndex + lightIndex * TCascadeCountBase_id151;
    return FilterThickness_id54(pixelPositionWS, meshNormalWS, DepthRanges_id156[arrayIndex], WorldToShadowCascadeUV_id153[arrayIndex], InverseWorldToShadowCascadeUV_id154[arrayIndex], isOrthographic);
}
float ComputeShadowFromCascade_id56(float3 shadowPositionWS, int cascadeIndex, int lightIndex)
{
    float4 shadowPosition = mul(float4(shadowPositionWS, 1.0), WorldToShadowCascadeUV_id153[cascadeIndex + lightIndex * TCascadeCountBase_id151]);
    shadowPosition.z -= DepthBiases_id157[lightIndex];
    shadowPosition.xyz /= shadowPosition.w;
    return FilterShadow_id53(shadowPosition.xy, shadowPosition.z);
}
float3 GetShadowPositionOffset_id55(float offsetScale, float nDotL, float3 normal)
{
    float normalOffsetScale = saturate(1.0f - nDotL);
    return 2.0f * ShadowMapTextureTexelSize_id91.x * offsetScale * normalOffsetScale * normal;
}
void PrepareEnvironmentLight_id86(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeSpecularTextureProjection_id77(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id76(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id75(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id74(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id175.Load(streams.lightIndex_id173);
    streams.lightIndex_id173++;
    SpotLightDataInternal spotLight;
    float4 spotLight1 = SpotLights_id180.Load(realLightIndex * 4);
    float4 spotLight2 = SpotLights_id180.Load(realLightIndex * 4 + 1);
    float4 spotLight3 = SpotLights_id180.Load(realLightIndex * 4 + 2);
    float4 spotLight4 = SpotLights_id180.Load(realLightIndex * 4 + 3);
    spotLight.PositionWS = spotLight1.xyz;
    spotLight.DirectionWS = spotLight2.xyz;
    spotLight.AngleOffsetAndInvSquareRadius = spotLight3.xyz;
    spotLight.Color = spotLight4.xyz;
    ProcessLight_id82(streams, spotLight);
}
float3 ComputeSpecularTextureProjection_id66(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id65(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id64(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id63(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id175.Load(streams.lightIndex_id173);
    streams.lightIndex_id173++;
    PointLightDataInternal pointLight;
    float4 pointLight1 = PointLights_id179.Load(realLightIndex * 2);
    float4 pointLight2 = PointLights_id179.Load(realLightIndex * 2 + 1);
    pointLight.PositionWS = pointLight1.xyz;
    pointLight.InvSquareRadius = pointLight1.w;
    pointLight.Color = pointLight2.xyz;
    ProcessLight_id71(streams, pointLight);
}
void PrepareLightData_id70(inout PS_STREAMS streams)
{
    float projectedDepth = streams.ShadingPosition_id0.z;
    float depth = ZProjection_id169.y / (projectedDepth - ZProjection_id169.x);
    float2 texCoord = float2(streams.ScreenPosition_id166.x + 1, 1 - streams.ScreenPosition_id166.y) * 0.5;
    int slice = int(max(log2(depth * ClusterDepthScale_id176 + ClusterDepthBias_id177), 0));
    streams.lightData_id172 = LightClusters_id174.Load(int4(texCoord * ClusterStride_id178, slice, 0));
    streams.lightIndex_id173 = streams.lightData_id172.x;
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
    int cascadeIndexBase = lightIndex * TCascadeCount_id159;
    int cascadeIndex = 0;

    [unroll]
    for (int i = 0; i < TCascadeCount_id159 - 1; i++)
    {
        [flatten]
        if (streams.DepthVS_id23 > CascadeDepthSplits_id165[cascadeIndexBase + i])
        {
            cascadeIndex = i + 1;
        }
    }
    float3 shadow = 1.0;
    float tempThickness = 999.0;
    float3 shadowPosition = position.xyz;
    shadowPosition += GetShadowPositionOffset_id55(OffsetScales_id158[lightIndex], streams.NdotL_id49, streams.normalWS_id19);
    if (cascadeIndex < TCascadeCount_id159)
    {
        shadow = ComputeShadowFromCascade_id56(shadowPosition, cascadeIndex, lightIndex);
        float nextSplit = CascadeDepthSplits_id165[cascadeIndexBase + cascadeIndex];
        float splitSize = nextSplit;
        if (cascadeIndex > 0)
        {
            splitSize = nextSplit - CascadeDepthSplits_id165[cascadeIndexBase + cascadeIndex - 1];
        }
        float splitDist = (nextSplit - streams.DepthVS_id23) / splitSize;
        if (splitDist < 0.2)
        {
            float lerpAmt = smoothstep(0.0, 0.2, splitDist);
            if (cascadeIndex == TCascadeCount_id159 - 1)
            {
            }
            else if (TBlendCascades_id161)
            {
                float nextShadow = ComputeShadowFromCascade_id56(shadowPosition, cascadeIndex + 1, lightIndex);
                shadow = lerp(nextShadow, shadow, lerpAmt);
            }
        }
    }
    streams.thicknessWS_id85 = tempThickness;
    return shadow;
}
void PrepareDirectLightCore_id46(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id88[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id88[lightIndex].DirectionWS;
}
void ResetStream_id101()
{
}
void AfterLightingAndShading_id171()
{
}
void PrepareEnvironmentLight_id160(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeEnvironmentLightContribution_id164(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor * streams.envLightDiffuseColor_id47;
}
void PrepareEnvironmentLight_id157(inout PS_STREAMS streams)
{
    PrepareEnvironmentLight_id86(streams);
    float3 lightColor = AmbientLight_id181 * streams.matAmbientOcclusion_id57;
    streams.envLightDiffuseColor_id47 = lightColor;
    streams.envLightSpecularColor_id48 = lightColor;
}
void PrepareDirectLight_id148(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id74(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id75(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id76(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id77(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id152(inout PS_STREAMS streams)
{
    return streams.lightData_id172.y >> 16;
}
int GetMaxLightCount_id151(inout PS_STREAMS streams)
{
    return streams.lightData_id172.y >> 16;
}
void PrepareDirectLights_id146()
{
}
void PrepareDirectLight_id135(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id63(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id64(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id65(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id66(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id140(inout PS_STREAMS streams)
{
    return streams.lightData_id172.y & 0xFFFF;
}
int GetMaxLightCount_id139(inout PS_STREAMS streams)
{
    return streams.lightData_id172.y & 0xFFFF;
}
void PrepareDirectLights_id138(inout PS_STREAMS streams)
{
    PrepareLightData_id70(streams);
}
float3 ComputeDirectLightContribution_id163(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor / PI_id185 * streams.lightColorNdotL_id44 * streams.matDiffuseSpecularAlphaBlend_id65.x;
}
void PrepareMaterialPerDirectLight_id30(inout PS_STREAMS streams)
{
    streams.H_id75 = normalize(streams.viewWS_id68 + streams.lightDirectionWS_id42);
    streams.NdotH_id76 = saturate(dot(streams.normalWS_id19, streams.H_id75));
    streams.LdotH_id77 = saturate(dot(streams.lightDirectionWS_id42, streams.H_id75));
    streams.VdotH_id78 = streams.LdotH_id77;
}
void PrepareDirectLight_id111(inout PS_STREAMS streams, int lightIndex)
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
int GetLightCount_id113()
{
    return LightCount_id86;
}
int GetMaxLightCount_id114()
{
    return TMaxLightCount_id87;
}
void PrepareDirectLights_id109()
{
}
void PrepareForLightingAndShading_id168()
{
}
void PrepareMaterialForLightingAndShading_id100(inout PS_STREAMS streams)
{
    streams.lightDirectAmbientOcclusion_id50 = lerp(1.0, streams.matAmbientOcclusion_id57, streams.matAmbientOcclusionDirectLightingFactor_id58);
    streams.matDiffuseVisible_id69 = streams.matDiffuse_id53.rgb * lerp(1.0f, streams.matCavity_id59, streams.matCavityDiffuse_id60) * streams.matDiffuseSpecularAlphaBlend_id65.r * streams.matAlphaBlendColor_id66;
    streams.matSpecularVisible_id71 = streams.matSpecular_id55.rgb * streams.matSpecularIntensity_id56 * lerp(1.0f, streams.matCavity_id59, streams.matCavitySpecular_id61) * streams.matDiffuseSpecularAlphaBlend_id65.g * streams.matAlphaBlendColor_id66;
    streams.NdotV_id72 = max(dot(streams.normalWS_id19, streams.viewWS_id68), 0.0001f);
    float roughness = 1.0f - streams.matGlossiness_id54;
    streams.alphaRoughness_id70 = max(roughness * roughness, 0.001);
}
void ResetLightStream_id99(inout PS_STREAMS streams)
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
float4 Compute_id161()
{
    return constantColor_id182;
}
void ResetStream_id102(inout PS_STREAMS streams)
{
    ResetStream_id101();
    streams.matBlend_id40 = 0.0f;
}
void Compute_id205(inout PS_STREAMS streams)
{
    UpdateNormalFromTangentSpace_id23(streams.matNormal_id51);
    if (!streams.IsFrontFace_id1)
        streams.normalWS_id19 = -streams.normalWS_id19;
    ResetLightStream_id99(streams);
    PrepareMaterialForLightingAndShading_id100(streams);

    {
        PrepareForLightingAndShading_id168();
    }
    float3 directLightingContribution = 0;

    {
        PrepareDirectLights_id109();
        const int maxLightCount = GetMaxLightCount_id114();
        int count = GetLightCount_id113();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id111(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id163(streams);
            }
        }
    }

    {
        PrepareDirectLights_id138(streams);
        const int maxLightCount = GetMaxLightCount_id139(streams);
        int count = GetLightCount_id140(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id135(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id163(streams);
            }
        }
    }

    {
        PrepareDirectLights_id146();
        const int maxLightCount = GetMaxLightCount_id151(streams);
        int count = GetLightCount_id152(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id148(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id163(streams);
            }
        }
    }
    float3 environmentLightingContribution = 0;

    {
        PrepareEnvironmentLight_id157(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id164(streams);
        }
    }

    {
        PrepareEnvironmentLight_id160(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id164(streams);
        }
    }
    streams.shadingColor_id73 += directLightingContribution * PI_id185 + environmentLightingContribution;
    streams.shadingColorAlpha_id74 = streams.matDiffuse_id53.a;

    {
        AfterLightingAndShading_id171();
    }
}
void Compute_id189(inout PS_STREAMS streams)
{
    float4 colorBase = Compute_id161();
    streams.matDiffuse_id53 = colorBase;
    streams.matColorBase_id52 = colorBase;
}
void ResetStream_id103(inout PS_STREAMS streams)
{
    ResetStream_id102(streams);
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
        Compute_id189(streams);
    }

    {
        Compute_id205(streams);
    }
}
void ResetStream_id42(inout PS_STREAMS streams)
{
    ResetStream_id103(streams);
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
    streams.ScreenPosition_id166 = __input__.ScreenPosition_id166;
    streams.IsFrontFace_id1 = __input__.IsFrontFace_id1;
    streams.ScreenPosition_id166 /= streams.ScreenPosition_id166.w;
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
    streams.ScreenPosition_id166 = streams.ShadingPosition_id0;
    VS_OUTPUT __output__ = (VS_OUTPUT)0;
    __output__.PositionWS_id22 = streams.PositionWS_id22;
    __output__.ShadingPosition_id0 = streams.ShadingPosition_id0;
    __output__.DepthVS_id23 = streams.DepthVS_id23;
    __output__.normalWS_id19 = streams.normalWS_id19;
    __output__.ScreenPosition_id166 = streams.ScreenPosition_id166;
    return __output__;
}
