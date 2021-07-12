/**************************
***** Compiler Parameters *****
***************************
@P EffectName: StrideForwardShadingEffect
@P   - Material.PixelStageSurfaceShaders: mixin MaterialSurfaceArray [{layers = [mixin MaterialSurfaceDiffuse [{diffuseMap = ComputeColorConstantColorLink<Material.DiffuseValue>}], mixin MaterialSurfaceLightingAndShading [{surfaces = [MaterialSurfaceShadingDiffuseLambert<false>]}]]}]
@P Material.PixelStageStreamInitializer: mixin MaterialStream, MaterialPixelShadingStream
@P Lighting.DirectLightGroups: mixin LightDirectionalGroup<1>, ShadowMapReceiverDirectional<4,1,true,true,false,false>, ShadowMapFilterDefault<PerView.Lighting>, mixin LightDirectionalGroup<1>, ShadowMapReceiverDirectional<4,1,true,true,false,false>, ShadowMapFilterPcf<PerView.Lighting,5>, LightClusteredPointGroup, LightClusteredSpotGroup
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
@C    constantColor_id205 => Material.DiffuseValue
cbuffer PerView [Size: 2416]
@C    View_id25 => Transformation.View
@C    ViewInverse_id26 => Transformation.ViewInverse
@C    Projection_id27 => Transformation.Projection
@C    ProjectionInverse_id28 => Transformation.ProjectionInverse
@C    ViewProjection_id29 => Transformation.ViewProjection
@C    ProjScreenRay_id30 => Transformation.ProjScreenRay
@C    Eye_id31 => Transformation.Eye
@C    NearClipPlane_id190 => Camera.NearClipPlane
@C    FarClipPlane_id191 => Camera.FarClipPlane
@C    ZProjection_id192 => Camera.ZProjection
@C    ViewSize_id193 => Camera.ViewSize
@C    AspectRatio_id194 => Camera.AspectRatio
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
@C    LightCount_id166 => DirectLightGroupPerView.LightCount.directLightGroups[1]
@C    Lights_id168 => LightDirectionalGroup.Lights.directLightGroups[1]
@C    ShadowMapTextureSize_id170 => ShadowMap.TextureSize.directLightGroups[1]
@C    ShadowMapTextureTexelSize_id171 => ShadowMap.TextureTexelSize.directLightGroups[1]
@C    WorldToShadowCascadeUV_id175 => ShadowMapReceiverBase.WorldToShadowCascadeUV.directLightGroups[1]
@C    InverseWorldToShadowCascadeUV_id176 => ShadowMapReceiverBase.InverseWorldToShadowCascadeUV.directLightGroups[1]
@C    ViewMatrices_id177 => ShadowMapReceiverBase.ViewMatrices.directLightGroups[1]
@C    DepthRanges_id178 => ShadowMapReceiverBase.DepthRanges.directLightGroups[1]
@C    DepthBiases_id179 => ShadowMapReceiverBase.DepthBiases.directLightGroups[1]
@C    OffsetScales_id180 => ShadowMapReceiverBase.OffsetScales.directLightGroups[1]
@C    CascadeDepthSplits_id187 => ShadowMapReceiverDirectional.CascadeDepthSplits.directLightGroups[1]
@C    ClusterDepthScale_id199 => LightClustered.ClusterDepthScale
@C    ClusterDepthBias_id200 => LightClustered.ClusterDepthBias
@C    ClusterStride_id201 => LightClustered.ClusterStride
@C    AmbientLight_id204 => LightSimpleAmbient.AmbientLight.environmentLights[0]
@C    _padding_PerView_Lighting => _padding_PerView_Lighting
***************************
******  Resources    ******
***************************
@R    PerMaterial => PerMaterial [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id169 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    ShadowMapTexture_id169 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: None, Slot: (-1--1)]
@R    LightClusters_id197 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightClusters_id197 => LightClustered.LightClusters [Stage: None, Slot: (-1--1)]
@R    LightIndices_id198 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    LightIndices_id198 => LightClustered.LightIndices [Stage: None, Slot: (-1--1)]
@R    PointLights_id202 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    PointLights_id202 => LightClusteredPointGroup.PointLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id203 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    SpotLights_id203 => LightClusteredSpotGroup.SpotLights [Stage: None, Slot: (-1--1)]
@R    PerDraw => PerDraw [Stage: Vertex, Slot: (0-0)]
@R    PerView => PerView [Stage: Vertex, Slot: (1-1)]
@R    LinearClampCompareLessEqualSampler_id124 => Texturing.LinearClampCompareLessEqualSampler [Stage: Pixel, Slot: (0-0)]
@R    ShadowMapTexture_id89 => ShadowMap.ShadowMapTexture.directLightGroups[0] [Stage: Pixel, Slot: (0-0)]
@R    ShadowMapTexture_id169 => ShadowMap.ShadowMapTexture.directLightGroups[1] [Stage: Pixel, Slot: (1-1)]
@R    LightClusters_id197 => LightClustered.LightClusters [Stage: Pixel, Slot: (2-2)]
@R    LightIndices_id198 => LightClustered.LightIndices [Stage: Pixel, Slot: (3-3)]
@R    PointLights_id202 => LightClusteredPointGroup.PointLights [Stage: Pixel, Slot: (4-4)]
@R    SpotLights_id203 => LightClusteredSpotGroup.SpotLights [Stage: Pixel, Slot: (5-5)]
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
@G    Vertex => 4ef8da3b68ca436ba9a5595e74d94dc4
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
//   float NearClipPlane_id190;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id191;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id192;          // Offset:  360 Size:     8 [unused]
//   float2 ViewSize_id193;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id194;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88;                     // Offset:  416 Size:    28 [unused]
//   float2 ShadowMapTextureSize_id90;  // Offset:  448 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id91;// Offset:  456 Size:     8 [unused]
//   float4x4 WorldToShadowCascadeUV_id153[4];// Offset:  464 Size:   256 [unused]
//   float4x4 InverseWorldToShadowCascadeUV_id154[4];// Offset:  720 Size:   256 [unused]
//   float4x4 ViewMatrices_id155[4];    // Offset:  976 Size:   256 [unused]
//   float2 DepthRanges_id156[4];       // Offset: 1232 Size:    56 [unused]
//   float DepthBiases_id157;           // Offset: 1296 Size:     4 [unused]
//   float OffsetScales_id158;          // Offset: 1312 Size:     4 [unused]
//   float CascadeDepthSplits_id165[4]; // Offset: 1328 Size:    52 [unused]
//   int LightCount_id166;              // Offset: 1380 Size:     4 [unused]
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset: 1392
//       float3 Color;                  // Offset: 1408
//
//   } Lights_id168;                    // Offset: 1392 Size:    28 [unused]
//   float2 ShadowMapTextureSize_id170; // Offset: 1424 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id171;// Offset: 1432 Size:     8 [unused]
//   float4x4 WorldToShadowCascadeUV_id175[4];// Offset: 1440 Size:   256 [unused]
//   float4x4 InverseWorldToShadowCascadeUV_id176[4];// Offset: 1696 Size:   256 [unused]
//   float4x4 ViewMatrices_id177[4];    // Offset: 1952 Size:   256 [unused]
//   float2 DepthRanges_id178[4];       // Offset: 2208 Size:    56 [unused]
//   float DepthBiases_id179;           // Offset: 2272 Size:     4 [unused]
//   float OffsetScales_id180;          // Offset: 2288 Size:     4 [unused]
//   float CascadeDepthSplits_id187[4]; // Offset: 2304 Size:    52 [unused]
//   float ClusterDepthScale_id199;     // Offset: 2356 Size:     4 [unused]
//   float ClusterDepthBias_id200;      // Offset: 2360 Size:     4 [unused]
//   float2 ClusterStride_id201;        // Offset: 2368 Size:     8 [unused]
//   float3 AmbientLight_id204;         // Offset: 2384 Size:    12 [unused]
//   float4 _padding_PerView_Lighting;  // Offset: 2400 Size:    16 [unused]
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
// SCREENPOSITION_ID189_SEM     0   xyzw        3     NONE   float   xyzw
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
//   o3.x <- <VSMain return value>.ScreenPosition_id189.x; o3.y <- <VSMain return value>.ScreenPosition_id189.y; o3.z <- <VSMain return value>.ScreenPosition_id189.z; o3.w <- <VSMain return value>.ScreenPosition_id189.w; 
//   o2.x <- <VSMain return value>.DepthVS_id23; o2.y <- <VSMain return value>.normalWS_id19.x; o2.z <- <VSMain return value>.normalWS_id19.y; o2.w <- <VSMain return value>.normalWS_id19.z; 
//   o1.x <- <VSMain return value>.ShadingPosition_id0.x; o1.y <- <VSMain return value>.ShadingPosition_id0.y; o1.z <- <VSMain return value>.ShadingPosition_id0.z; o1.w <- <VSMain return value>.ShadingPosition_id0.w; 
//   o0.x <- <VSMain return value>.PositionWS_id22.x; o0.y <- <VSMain return value>.PositionWS_id22.y; o0.z <- <VSMain return value>.PositionWS_id22.z; o0.w <- <VSMain return value>.PositionWS_id22.w
//
#line 1160 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_b0984abf8a4c95cb22bcca4431c767aa.hlsl"
dp4 r0.x, v0.xyzw, cb0[0].xyzw  // r0.x <- streams.PositionWS_id22.x
dp4 r0.y, v0.xyzw, cb0[1].xyzw  // r0.y <- streams.PositionWS_id22.y
dp4 r0.z, v0.xyzw, cb0[2].xyzw  // r0.z <- streams.PositionWS_id22.z
dp4 r0.w, v0.xyzw, cb0[3].xyzw  // r0.w <- streams.PositionWS_id22.w

#line 1247
mov o0.xyzw, r0.xyzw

#line 1123
dp4 r1.x, r0.xyzw, cb1[16].xyzw  // r1.x <- <ComputeShadingPosition_id11 return value>.x
dp4 r1.y, r0.xyzw, cb1[17].xyzw  // r1.y <- <ComputeShadingPosition_id11 return value>.y
dp4 r1.z, r0.xyzw, cb1[18].xyzw  // r1.z <- <ComputeShadingPosition_id11 return value>.z
dp4 r1.w, r0.xyzw, cb1[19].xyzw  // r1.w <- <ComputeShadingPosition_id11 return value>.w

#line 1247
mov o1.xyzw, r1.xyzw
mov o3.xyzw, r1.xyzw
mov o2.x, r1.w

#line 1200
dp3 o2.y, v1.xyzx, cb0[8].xyzx
dp3 o2.z, v1.xyzx, cb0[9].xyzx
dp3 o2.w, v1.xyzx, cb0[10].xyzx

#line 1247
ret 
// Approximately 16 instruction slots used
@G    Pixel => ffac1eaeea51ca9195b0dc4102e634eb
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
//   float4 constantColor_id205;        // Offset:    0 Size:    16
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
//   float NearClipPlane_id190;         // Offset:  352 Size:     4 [unused]
//      = 0x3f800000 
//   float FarClipPlane_id191;          // Offset:  356 Size:     4 [unused]
//      = 0x42c80000 
//   float2 ZProjection_id192;          // Offset:  360 Size:     8
//   float2 ViewSize_id193;             // Offset:  368 Size:     8 [unused]
//   float AspectRatio_id194;           // Offset:  376 Size:     4 [unused]
//   float4 _padding_PerView_Default;   // Offset:  384 Size:    16 [unused]
//   int LightCount_id86;               // Offset:  400 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset:  416
//       float3 Color;                  // Offset:  432
//
//   } Lights_id88;                     // Offset:  416 Size:    28
//   float2 ShadowMapTextureSize_id90;  // Offset:  448 Size:     8 [unused]
//   float2 ShadowMapTextureTexelSize_id91;// Offset:  456 Size:     8
//   float4x4 WorldToShadowCascadeUV_id153[4];// Offset:  464 Size:   256
//   float4x4 InverseWorldToShadowCascadeUV_id154[4];// Offset:  720 Size:   256 [unused]
//   float4x4 ViewMatrices_id155[4];    // Offset:  976 Size:   256 [unused]
//   float2 DepthRanges_id156[4];       // Offset: 1232 Size:    56 [unused]
//   float DepthBiases_id157;           // Offset: 1296 Size:     4
//   float OffsetScales_id158;          // Offset: 1312 Size:     4
//   float CascadeDepthSplits_id165[4]; // Offset: 1328 Size:    52
//   int LightCount_id166;              // Offset: 1380 Size:     4
//   
//   struct DirectionalLightData
//   {
//       
//       float3 DirectionWS;            // Offset: 1392
//       float3 Color;                  // Offset: 1408
//
//   } Lights_id168;                    // Offset: 1392 Size:    28
//   float2 ShadowMapTextureSize_id170; // Offset: 1424 Size:     8
//   float2 ShadowMapTextureTexelSize_id171;// Offset: 1432 Size:     8
//   float4x4 WorldToShadowCascadeUV_id175[4];// Offset: 1440 Size:   256
//   float4x4 InverseWorldToShadowCascadeUV_id176[4];// Offset: 1696 Size:   256 [unused]
//   float4x4 ViewMatrices_id177[4];    // Offset: 1952 Size:   256 [unused]
//   float2 DepthRanges_id178[4];       // Offset: 2208 Size:    56 [unused]
//   float DepthBiases_id179;           // Offset: 2272 Size:     4
//   float OffsetScales_id180;          // Offset: 2288 Size:     4
//   float CascadeDepthSplits_id187[4]; // Offset: 2304 Size:    52
//   float ClusterDepthScale_id199;     // Offset: 2356 Size:     4
//   float ClusterDepthBias_id200;      // Offset: 2360 Size:     4
//   float2 ClusterStride_id201;        // Offset: 2368 Size:     8
//   float3 AmbientLight_id204;         // Offset: 2384 Size:    12
//   float4 _padding_PerView_Lighting;  // Offset: 2400 Size:    16 [unused]
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
// ShadowMapTexture_id169            texture  float4          2d             t1      1 
// LightClusters_id197               texture   uint2          3d             t2      1 
// LightIndices_id198                texture    uint         buf             t3      1 
// PointLights_id202                 texture  float4         buf             t4      1 
// SpotLights_id203                  texture  float4         buf             t5      1 
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
// SCREENPOSITION_ID189_SEM     0   xyzw        3     NONE   float   xy w
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
dcl_constantbuffer CB2[150], dynamicIndexed
dcl_sampler s0, mode_comparison
dcl_resource_texture2d (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t1
dcl_resource_texture3d (uint,uint,uint,uint) t2
dcl_resource_buffer (uint,uint,uint,uint) t3
dcl_resource_buffer (float,float,float,float) t4
dcl_resource_buffer (float,float,float,float) t5
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
//   v3.x <- __input__.ScreenPosition_id189.x; v3.y <- __input__.ScreenPosition_id189.y; v3.z <- __input__.ScreenPosition_id189.z; v3.w <- __input__.ScreenPosition_id189.w; 
//   v4.x <- __input__.IsFrontFace_id1; 
//   o1.x <- <PSMain return value>.ColorTarget1_id3.x; o1.y <- <PSMain return value>.ColorTarget1_id3.y; o1.z <- <PSMain return value>.ColorTarget1_id3.z; o1.w <- <PSMain return value>.ColorTarget1_id3.w; 
//   o0.x <- <PSMain return value>.ColorTarget_id2.x; o0.y <- <PSMain return value>.ColorTarget_id2.y; o0.z <- <PSMain return value>.ColorTarget_id2.z; o0.w <- <PSMain return value>.ColorTarget_id2.w
//
#line 1227 "C:\Program Files\vvvv\vvvv_gamma_2021.3.0-0042-g1caddcdcf2\lib\log\shader_StrideForwardShadingEffect_b0984abf8a4c95cb22bcca4431c767aa.hlsl"
div r0.xy, v3.xyxx, v3.wwww  // r0.x <- streams.ScreenPosition_id189.x; r0.y <- streams.ScreenPosition_id189.y

#line 1194
dp3 r0.z, v2.yzwy, v2.yzwy
lt r0.w, l(0.000000), r0.z

#line 1195
rsq r0.z, r0.z
mul r1.xyz, r0.zzzz, v2.yzwy  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z
movc r1.xyz, r0.wwww, r1.xyzx, v2.yzwy

#line 979
movc r1.xyz, v4.xxxx, r1.xyzx, -r1.xyzx  // r1.x <- streams.normalWS_id19.x; r1.y <- streams.normalWS_id19.y; r1.z <- streams.normalWS_id19.z

#line 999
ilt r0.z, l(0), cb2[25].x
if_nz r0.z

#line 919
  dp3 r0.z, r1.xyzx, -cb2[26].xyzx
  max r0.z, r0.z, l(0.000100)  // r0.z <- streams.NdotL_id49

#line 774
  lt r0.w, cb2[83].x, v2.x

#line 777
  and r0.w, r0.w, l(1)  // r0.w <- cascadeIndex

#line 774
  lt r1.w, cb2[84].x, v2.x

#line 777
  movc r0.w, r1.w, l(2), r0.w

#line 774
  lt r1.w, cb2[85].x, v2.x

#line 777
  movc r0.w, r1.w, l(3), r0.w

#line 630
  add r2.x, -r0.z, l(1.000000)
  max r2.x, r2.x, l(0.000000)  // r2.x <- normalOffsetScale

#line 631
  mul r2.y, cb2[28].z, cb2[82].x
  dp2 r2.x, r2.yyyy, r2.xxxx

#line 782
  mad r2.xyz, r2.xxxx, r1.xyzx, v0.xyzx  // r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z

#line 623
  ishl r3.x, r0.w, l(2)
  mov r2.w, l(1.000000)
  dp4 r4.x, r2.xyzw, cb2[r3.x + 29].xyzw  // r4.x <- shadowPosition.x
  dp4 r4.y, r2.xyzw, cb2[r3.x + 30].xyzw  // r4.y <- shadowPosition.y
  dp4 r3.y, r2.xyzw, cb2[r3.x + 31].xyzw  // r3.y <- shadowPosition.z
  dp4 r3.z, r2.xyzw, cb2[r3.x + 32].xyzw  // r3.z <- shadowPosition.w

#line 624
  add r4.z, r3.y, -cb2[81].x  // r4.z <- shadowPosition.z

#line 625
  div r3.yzw, r4.xxyz, r3.zzzz  // r3.y <- shadowPosition.x; r3.z <- shadowPosition.y; r3.w <- shadowPosition.z

#line 580
  sample_c_lz_indexable(texture2d)(float,float,float,float) r3.y, r3.yzyy, t0.xxxx, s0, r3.w  // r3.y <- <FilterShadow_id54 return value>

#line 788
  ilt r3.z, l(0), r0.w
  if_nz r3.z

#line 790
    iadd r3.z, r0.w, l(-1)
    add r3.z, -cb2[r3.z + 83].x, cb2[r0.w + 83].x  // r3.z <- splitSize

#line 791
  else 
    mov r3.z, cb2[r0.w + 83].x  // r3.z <- splitSize
  endif 

#line 792
  add r0.w, -v2.x, cb2[r0.w + 83].x
  div r0.w, r0.w, r3.z  // r0.w <- splitDist

#line 793
  lt r3.z, r0.w, l(0.200000)
  if_nz r3.z

#line 796
    if_nz r1.w

#line 798
      mov r4.xyz, r3.yyyy  // r4.x <- shadow.x; r4.y <- shadow.y; r4.z <- shadow.z
    else 

#line 795
      mul_sat r0.w, r0.w, l(5.000000)
      mad r1.w, r0.w, l(-2.000000), l(3.000000)
      mul r0.w, r0.w, r0.w
      mul r0.w, r0.w, r1.w  // r0.w <- lerpAmt

#line 623
      dp4 r5.x, r2.xyzw, cb2[r3.x + 33].xyzw  // r5.x <- shadowPosition.x
      dp4 r5.y, r2.xyzw, cb2[r3.x + 34].xyzw  // r5.y <- shadowPosition.y
      dp4 r1.w, r2.xyzw, cb2[r3.x + 35].xyzw  // r1.w <- shadowPosition.z
      dp4 r2.x, r2.xyzw, cb2[r3.x + 36].xyzw  // r2.x <- shadowPosition.w

#line 624
      add r5.z, r1.w, -cb2[81].x  // r5.z <- shadowPosition.z

#line 625
      div r2.xyz, r5.xyzx, r2.xxxx  // r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z

#line 580
      sample_c_lz_indexable(texture2d)(float,float,float,float) r1.w, r2.xyxx, t0.xxxx, s0, r2.z  // r1.w <- <FilterShadow_id54 return value>

#line 802
      add r2.x, -r1.w, r3.y
      mad r4.xyz, r0.wwww, r2.xxxx, r1.wwww  // r4.x <- shadow.x; r4.y <- shadow.y; r4.z <- shadow.z

#line 803
    endif 

#line 804
  else   // Prior locations: r2.x <- shadowPosition.x; r2.y <- shadowPosition.y; r2.z <- shadowPosition.z; r0.w <- splitDist
    mov r4.xyz, r3.yyyy  // r4.x <- shadow.x; r4.y <- shadow.y; r4.z <- shadow.z
  endif 

#line 921
  mul r2.xyz, r4.xyzx, cb2[27].xyzx
  mul r2.xyz, r0.zzzz, r2.xyzx  // r2.x <- streams.lightColorNdotL_id44.x; r2.y <- streams.lightColorNdotL_id44.y; r2.z <- streams.lightColorNdotL_id44.z

#line 907
  mul r2.xyz, r2.xyzx, cb1[0].xyzx
  mul r2.xyz, r2.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000)  // r2.x <- <ComputeDirectLightContribution_id212 return value>.x; r2.y <- <ComputeDirectLightContribution_id212 return value>.y; r2.z <- <ComputeDirectLightContribution_id212 return value>.z

#line 1004
else 
  mov r2.xyz, l(0,0,0,0)
endif 

#line 1019
ilt r0.z, l(0), cb2[86].y
if_nz r0.z

#line 885
  dp3 r0.z, r1.xyzx, -cb2[87].xyzx
  max r0.z, r0.z, l(0.000100)  // r0.z <- streams.NdotL_id49

#line 717
  lt r0.w, cb2[144].x, v2.x

#line 720
  and r0.w, r0.w, l(1)  // r0.w <- cascadeIndex

#line 717
  lt r1.w, cb2[145].x, v2.x

#line 720
  movc r0.w, r1.w, l(2), r0.w

#line 717
  lt r1.w, cb2[146].x, v2.x

#line 720
  movc r0.w, r1.w, l(3), r0.w

#line 613
  add r2.w, -r0.z, l(1.000000)
  max r2.w, r2.w, l(0.000000)  // r2.w <- normalOffsetScale

#line 614
  mul r3.x, cb2[89].z, cb2[143].x
  dp2 r2.w, r3.xxxx, r2.wwww

#line 725
  mad r3.xyz, r2.wwww, r1.xyzx, v0.xyzx  // r3.x <- shadowPosition.x; r3.y <- shadowPosition.y; r3.z <- shadowPosition.z

#line 606
  ishl r2.w, r0.w, l(2)
  mov r3.w, l(1.000000)
  dp4 r4.x, r3.xyzw, cb2[r2.w + 90].xyzw  // r4.x <- shadowPosition.x
  dp4 r4.y, r3.xyzw, cb2[r2.w + 91].xyzw  // r4.y <- shadowPosition.y
  dp4 r4.w, r3.xyzw, cb2[r2.w + 92].xyzw  // r4.w <- shadowPosition.z
  dp4 r5.x, r3.xyzw, cb2[r2.w + 93].xyzw  // r5.x <- shadowPosition.w

#line 607
  add r4.z, r4.w, -cb2[142].x  // r4.z <- shadowPosition.z

#line 608
  div r4.xyz, r4.xyzx, r5.xxxx

#line 468
  mad r4.xy, r4.xyxx, cb2[89].xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  round_ni r5.xy, r4.xyxx  // r5.x <- base_uv.x; r5.y <- base_uv.y

#line 469
  add r4.xy, r4.xyxx, -r5.xyxx  // r4.x <- st.x; r4.y <- st.y

#line 470
  add r5.xy, r5.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)

#line 471
  mul r5.xy, r5.xyxx, cb2[89].zwzz

#line 326
  mad r5.zw, -r4.yyyx, l(0.000000, 0.000000, 3.000000, 3.000000), l(0.000000, 0.000000, 4.000000, 4.000000)  // r5.z <- uvW0.y; r5.w <- uvW0.x

#line 328
  mad r6.xy, r4.xyxx, l(3.000000, 3.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)  // r6.x <- uvW2.x; r6.y <- uvW2.y

#line 329
  mad r6.zw, -r4.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
  div r6.zw, r6.zzzw, r5.wwwz
  add r7.xw, r6.zzzw, l(-2.000000, 0.000000, 0.000000, -2.000000)  // r7.x <- uv0.x; r7.w <- uv0.y

#line 330
  add r6.zw, r4.xxxy, l(0.000000, 0.000000, 3.000000, 3.000000)
  mul r7.yz, r6.wwzw, l(0.000000, 0.142857, 0.142857, 0.000000)  // r7.y <- uv1.y; r7.z <- uv1.x

#line 331
  div r4.xy, r4.xyxx, r6.xyxx
  add r8.xy, r4.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000)  // r8.x <- uv2.x; r8.y <- uv2.y

#line 332
  mul r4.x, r5.z, r5.w

#line 333
  mad r9.xyzw, r7.xwzw, cb2[89].zwzw, r5.xyxy

#line 337
  mov r8.zw, r7.wwwy

#line 335
  mul r4.yw, r5.zzzw, l(0.000000, 7.000000, 0.000000, 7.000000)

#line 336
  mad r10.xyzw, r7.xyzy, cb2[89].zwzw, r5.xyxy

#line 337
  mad r11.xyzw, r8.xzxw, cb2[89].zwzw, r5.xyxy

#line 338
  mov r7.y, r8.y
  mul r5.zw, r5.zzzw, r6.xxxy

#line 339
  mad r7.xyzw, r7.xyzy, cb2[89].zwzw, r5.xyxy
  mul r6.zw, r6.xxxy, l(0.000000, 0.000000, 7.000000, 7.000000)

#line 340
  mad r5.xy, r8.xyxx, cb2[89].zwzz, r5.xyxx
  mul r6.x, r6.y, r6.x

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r6.y, r9.xyxx, t1.xxxx, s0, r4.z  // r6.y <- <SampleTextureAndCompare_id78 return value>
  sample_c_lz_indexable(texture2d)(float,float,float,float) r8.x, r9.zwzz, t1.xxxx, s0, r4.z  // r8.x <- <SampleTextureAndCompare_id78 return value>

#line 557
  mul r4.y, r4.y, r8.x
  mad r4.x, r4.x, r6.y, r4.y  // r4.x <- shadow

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r11.xyxx, t1.xxxx, s0, r4.z  // r4.y <- <SampleTextureAndCompare_id78 return value>

#line 557
  mad r4.x, r5.z, r4.y, r4.x

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r10.xyxx, t1.xxxx, s0, r4.z

#line 557
  mad r4.x, r4.w, r4.y, r4.x

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r10.zwzz, t1.xxxx, s0, r4.z

#line 557
  mad r4.x, r4.y, l(49.000000), r4.x

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r11.zwzz, t1.xxxx, s0, r4.z

#line 557
  mad r4.x, r6.z, r4.y, r4.x

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r7.xyxx, t1.xxxx, s0, r4.z

#line 557
  mad r4.x, r5.w, r4.y, r4.x

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r7.zwzz, t1.xxxx, s0, r4.z

#line 557
  mad r4.x, r6.w, r4.y, r4.x

#line 463
  sample_c_lz_indexable(texture2d)(float,float,float,float) r4.y, r5.xyxx, t1.xxxx, s0, r4.z

#line 557
  mad r4.x, r6.x, r4.y, r4.x

#line 559
  mul r4.yzw, r4.xxxx, l(0.000000, 0.006944, 0.006944, 0.006944)  // r4.w <- shadow

#line 731
  ilt r5.x, l(0), r0.w
  if_nz r5.x

#line 733
    iadd r5.x, r0.w, l(-1)
    add r5.x, -cb2[r5.x + 144].x, cb2[r0.w + 144].x  // r5.x <- splitSize

#line 734
  else 
    mov r5.x, cb2[r0.w + 144].x  // r5.x <- splitSize
  endif 

#line 735
  add r0.w, -v2.x, cb2[r0.w + 144].x
  div r0.w, r0.w, r5.x  // r0.w <- splitDist

#line 736
  lt r5.x, r0.w, l(0.200000)
  if_nz r5.x

#line 739
    if_nz r1.w

#line 741
      mov r4.yzw, r4.wwww  // r4.y <- shadow.x; r4.z <- shadow.y; r4.w <- shadow.z
    else 

#line 738
      mul_sat r0.w, r0.w, l(5.000000)
      mad r1.w, r0.w, l(-2.000000), l(3.000000)
      mul r0.w, r0.w, r0.w
      mul r0.w, r0.w, r1.w  // r0.w <- lerpAmt

#line 606
      dp4 r5.x, r3.xyzw, cb2[r2.w + 94].xyzw  // r5.x <- shadowPosition.x
      dp4 r5.y, r3.xyzw, cb2[r2.w + 95].xyzw  // r5.y <- shadowPosition.y
      dp4 r1.w, r3.xyzw, cb2[r2.w + 96].xyzw  // r1.w <- shadowPosition.z
      dp4 r2.w, r3.xyzw, cb2[r2.w + 97].xyzw  // r2.w <- shadowPosition.w

#line 607
      add r5.z, r1.w, -cb2[142].x  // r5.z <- shadowPosition.z

#line 608
      div r3.xyz, r5.xyzx, r2.wwww  // r3.x <- shadowPosition.x; r3.y <- shadowPosition.y; r3.z <- shadowPosition.z

#line 468
      mad r3.xy, r3.xyxx, cb2[89].xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
      round_ni r5.xy, r3.xyxx  // r5.x <- base_uv.x; r5.y <- base_uv.y

#line 469
      add r3.xy, r3.xyxx, -r5.xyxx  // r3.x <- st.x; r3.y <- st.y

#line 470
      add r5.xy, r5.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)

#line 471
      mul r5.xy, r5.xyxx, cb2[89].zwzz

#line 326
      mad r5.zw, -r3.yyyx, l(0.000000, 0.000000, 3.000000, 3.000000), l(0.000000, 0.000000, 4.000000, 4.000000)  // r5.z <- uvW0.y; r5.w <- uvW0.x

#line 328
      mad r6.xy, r3.xyxx, l(3.000000, 3.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)  // r6.x <- uvW2.x; r6.y <- uvW2.y

#line 329
      mad r6.zw, -r3.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
      div r6.zw, r6.zzzw, r5.wwwz
      add r7.xw, r6.zzzw, l(-2.000000, 0.000000, 0.000000, -2.000000)  // r7.x <- uv0.x; r7.w <- uv0.y

#line 330
      add r6.zw, r3.xxxy, l(0.000000, 0.000000, 3.000000, 3.000000)
      mul r7.yz, r6.wwzw, l(0.000000, 0.142857, 0.142857, 0.000000)  // r7.y <- uv1.y; r7.z <- uv1.x

#line 331
      div r3.xy, r3.xyxx, r6.xyxx
      add r8.xy, r3.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000)  // r8.x <- uv2.x; r8.y <- uv2.y

#line 332
      mul r1.w, r5.z, r5.w

#line 333
      mad r9.xyzw, r7.xwzw, cb2[89].zwzw, r5.xyxy

#line 337
      mov r8.zw, r7.wwwy

#line 335
      mul r3.xy, r5.zwzz, l(7.000000, 7.000000, 0.000000, 0.000000)

#line 336
      mad r10.xyzw, r7.xyzy, cb2[89].zwzw, r5.xyxy

#line 337
      mad r11.xyzw, r8.xzxw, cb2[89].zwzw, r5.xyxy

#line 338
      mov r7.y, r8.y
      mul r5.zw, r5.zzzw, r6.xxxy

#line 339
      mad r7.xyzw, r7.xyzy, cb2[89].zwzw, r5.xyxy
      mul r6.zw, r6.xxxy, l(0.000000, 0.000000, 7.000000, 7.000000)

#line 340
      mad r5.xy, r8.xyxx, cb2[89].zwzz, r5.xyxx
      mul r2.w, r6.y, r6.x

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.w, r9.xyxx, t1.xxxx, s0, r3.z  // r3.w <- <SampleTextureAndCompare_id78 return value>
      sample_c_lz_indexable(texture2d)(float,float,float,float) r6.x, r9.zwzz, t1.xxxx, s0, r3.z  // r6.x <- <SampleTextureAndCompare_id78 return value>

#line 557
      mul r3.x, r3.x, r6.x
      mad r1.w, r1.w, r3.w, r3.x  // r1.w <- shadow

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.x, r11.xyxx, t1.xxxx, s0, r3.z  // r3.x <- <SampleTextureAndCompare_id78 return value>

#line 557
      mad r1.w, r5.z, r3.x, r1.w

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.x, r10.xyxx, t1.xxxx, s0, r3.z

#line 557
      mad r1.w, r3.y, r3.x, r1.w

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.x, r10.zwzz, t1.xxxx, s0, r3.z

#line 557
      mad r1.w, r3.x, l(49.000000), r1.w

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.x, r11.zwzz, t1.xxxx, s0, r3.z

#line 557
      mad r1.w, r6.z, r3.x, r1.w

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.x, r7.xyxx, t1.xxxx, s0, r3.z

#line 557
      mad r1.w, r5.w, r3.x, r1.w

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.x, r7.zwzz, t1.xxxx, s0, r3.z

#line 557
      mad r1.w, r6.w, r3.x, r1.w

#line 463
      sample_c_lz_indexable(texture2d)(float,float,float,float) r3.x, r5.xyxx, t1.xxxx, s0, r3.z

#line 557
      mad r1.w, r2.w, r3.x, r1.w

#line 559
      mul r1.w, r1.w, l(0.006944)

#line 745
      mad r2.w, r4.x, l(0.006944), -r1.w
      mad r4.yzw, r0.wwww, r2.wwww, r1.wwww  // r4.y <- shadow.x; r4.z <- shadow.y; r4.w <- shadow.z

#line 746
    endif 

#line 747
  endif 

#line 887
  mul r3.xyz, r4.yzwy, cb2[88].xyzx
  mul r3.xyz, r0.zzzz, r3.xyzx  // r3.x <- streams.lightColorNdotL_id44.x; r3.y <- streams.lightColorNdotL_id44.y; r3.z <- streams.lightColorNdotL_id44.z

#line 907
  mul r3.xyz, r3.xyzx, cb1[0].xyzx

#line 1023
  mad r2.xyz, r3.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r2.xyzx  // r2.x <- directLightingContribution.x; r2.y <- directLightingContribution.y; r2.z <- directLightingContribution.z

#line 1024
endif 

#line 694
add r0.z, v1.z, -cb2[22].z
div r0.z, cb2[22].w, r0.z  // r0.z <- depth

#line 695
mad r0.xy, r0.xyxx, l(1.000000, -1.000000, 0.000000, 0.000000), l(1.000000, 1.000000, 0.000000, 0.000000)
mul r0.xy, r0.xyxx, cb2[148].xyxx

#line 696
mad r0.z, r0.z, cb2[147].y, cb2[147].z
log r0.z, r0.z
max r0.z, r0.z, l(0.000000)

#line 697
mul r0.xy, r0.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)

#line 696
ftoi r3.xyz, r0.xyzx  // r3.z <- slice

#line 697
mov r3.w, l(0)
ld_indexable(texture3d)(uint,uint,uint,uint) r0.xy, r3.xyzw, t2.xyzw  // r0.x <- streams.lightData_id195.x; r0.y <- streams.lightData_id195.y

#line 876
and r0.z, r0.y, l(0x0000ffff)  // r0.z <- <GetMaxLightCount_id188 return value>

#line 1033
mov r3.xyz, r1.xyzx  // r3.x <- streams.normalWS_id19.x; r3.y <- streams.normalWS_id19.y; r3.z <- streams.normalWS_id19.z
mov r3.w, v0.x  // r3.w <- streams.PositionWS_id22.x
mov r4.yz, v0.yyzy  // r4.y <- streams.PositionWS_id22.y; r4.z <- streams.PositionWS_id22.z
mov r5.xyz, cb1[0].xyzx  // r5.x <- streams.matDiffuseVisible_id69.x; r5.y <- streams.matDiffuseVisible_id69.y; r5.z <- streams.matDiffuseVisible_id69.z
mov r6.xyz, r2.xyzx  // r6.x <- directLightingContribution.x; r6.y <- directLightingContribution.y; r6.z <- directLightingContribution.z
mov r7.x, r0.x  // r7.x <- streams.lightIndex_id196
mov r0.w, l(0)  // r0.w <- i
loop 
  ige r1.w, r0.w, r0.z
  breakc_nz r1.w

#line 1035
  if_nz r1.w

#line 1037
    break 

#line 1038
  endif 

#line 681
  ld_indexable(buffer)(uint,uint,uint,uint) r1.w, r7.xxxx, t3.yzwx  // r1.w <- realLightIndex

#line 682
  iadd r7.x, r7.x, l(1)  // r7.x <- streams.lightIndex_id196

#line 684
  ishl r2.w, r1.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r8.xyzw, r2.wwww, t4.xyzw  // r8.x <- pointLight1.x; r8.y <- pointLight1.y; r8.z <- pointLight1.z; r8.w <- pointLight1.w

#line 685
  bfi r1.w, l(31), l(1), r1.w, l(1)
  ld_indexable(buffer)(float,float,float,float) r7.yzw, r1.wwww, t4.wxyz  // r7.y <- pointLight2.x; r7.z <- pointLight2.y; r7.w <- pointLight2.z

#line 523
  mov r4.x, r3.w
  add r8.xyz, -r4.xyzx, r8.xyzx  // r8.x <- lightVector.x; r8.y <- lightVector.y; r8.z <- lightVector.z

#line 524
  dp3 r1.w, r8.xyzx, r8.xyzx
  sqrt r2.w, r1.w  // r2.w <- lightVectorLength

#line 525
  div r8.xyz, r8.xyzx, r2.wwww  // r8.x <- lightVectorNorm.x; r8.y <- lightVectorNorm.y; r8.z <- lightVectorNorm.z

#line 409
  max r2.w, r1.w, l(0.000100)
  div r2.w, l(1.000000, 1.000000, 1.000000, 1.000000), r2.w  // r2.w <- attenuation

#line 308
  mul r1.w, r8.w, r1.w  // r1.w <- factor

#line 309
  mad r1.w, -r1.w, r1.w, l(1.000000)
  max r1.w, r1.w, l(0.000000)  // r1.w <- smoothFactor

#line 310
  mul r1.w, r1.w, r1.w  // r1.w <- <SmoothDistanceAttenuation_id92 return value>

#line 410
  mul r1.w, r1.w, r2.w  // r1.w <- attenuation

#line 862
  dp3 r2.w, r3.xyzx, r8.xyzx
  max r2.w, r2.w, l(0.000100)  // r2.w <- streams.NdotL_id49

#line 864
  mul r7.yzw, r1.wwww, r7.yyzw
  mul r7.yzw, r2.wwww, r7.yyzw  // r7.y <- streams.lightColorNdotL_id44.x; r7.z <- streams.lightColorNdotL_id44.y; r7.w <- streams.lightColorNdotL_id44.z

#line 907
  mul r7.yzw, r7.yyzw, r5.xxyz

#line 1043
  mad r6.xyz, r7.yzwy, l(0.318310, 0.318310, 0.318310, 0.000000), r6.xyzx

#line 1033
  iadd r0.w, r0.w, l(1)

#line 1045
endloop   // r7.x <- streams.lightIndex_id196

#line 854
ushr r0.x, r0.y, l(16)  // r0.x <- <GetMaxLightCount_id200 return value>

#line 1053
mov r2.xyz, r1.xyzx  // r2.x <- streams.normalWS_id19.x; r2.y <- streams.normalWS_id19.y; r2.z <- streams.normalWS_id19.z
mov r2.w, v0.x  // r2.w <- streams.PositionWS_id22.x
mov r3.yz, v0.yyzy  // r3.y <- streams.PositionWS_id22.y; r3.z <- streams.PositionWS_id22.z
mov r0.yzw, cb1[0].xxyz  // r0.y <- streams.matDiffuseVisible_id69.x; r0.z <- streams.matDiffuseVisible_id69.y; r0.w <- streams.matDiffuseVisible_id69.z
mov r4.xyz, r6.xyzx  // r4.x <- directLightingContribution.x; r4.y <- directLightingContribution.y; r4.z <- directLightingContribution.z
mov r1.w, r7.x  // r1.w <- streams.lightIndex_id196
mov r3.w, l(0)  // r3.w <- i
loop 
  ige r4.w, r3.w, r0.x
  breakc_nz r4.w

#line 1055
  if_nz r4.w

#line 1057
    break 

#line 1058
  endif 

#line 653
  ld_indexable(buffer)(uint,uint,uint,uint) r4.w, r1.wwww, t3.yzwx  // r4.w <- realLightIndex

#line 654
  iadd r1.w, r1.w, l(1)  // r1.w <- streams.lightIndex_id196

#line 656
  ishl r5.x, r4.w, l(2)
  ld_indexable(buffer)(float,float,float,float) r5.xyz, r5.xxxx, t5.xyzw  // r5.x <- spotLight1.x; r5.y <- spotLight1.y; r5.z <- spotLight1.z

#line 659
  bfi r7.yzw, l(0, 30, 30, 30), l(0, 2, 2, 2), r4.wwww, l(0, 1, 2, 3)

#line 657
  ld_indexable(buffer)(float,float,float,float) r8.xyz, r7.yyyy, t5.xyzw  // r8.x <- spotLight2.x; r8.y <- spotLight2.y; r8.z <- spotLight2.z

#line 658
  ld_indexable(buffer)(float,float,float,float) r9.xyz, r7.zzzz, t5.xyzw  // r9.x <- spotLight3.x; r9.y <- spotLight3.y; r9.z <- spotLight3.z

#line 659
  ld_indexable(buffer)(float,float,float,float) r7.yzw, r7.wwww, t5.wxyz  // r7.y <- spotLight4.x; r7.z <- spotLight4.y; r7.w <- spotLight4.z

#line 510
  mov r3.x, r2.w
  add r5.xyz, -r3.xyzx, r5.xyzx  // r5.x <- lightVector.x; r5.y <- lightVector.y; r5.z <- lightVector.z

#line 511
  dp3 r3.x, r5.xyzx, r5.xyzx
  sqrt r4.w, r3.x  // r4.w <- lightVectorLength

#line 512
  div r5.xyz, r5.xyzx, r4.wwww  // r5.x <- lightVectorNorm.x; r5.y <- lightVectorNorm.y; r5.z <- lightVectorNorm.z

#line 402
  max r4.w, r3.x, l(0.000100)
  div r4.w, l(1.000000, 1.000000, 1.000000, 1.000000), r4.w  // r4.w <- attenuation

#line 302
  mul r3.x, r9.z, r3.x  // r3.x <- factor

#line 303
  mad r3.x, -r3.x, r3.x, l(1.000000)
  max r3.x, r3.x, l(0.000000)  // r3.x <- smoothFactor

#line 304
  mul r3.x, r3.x, r3.x  // r3.x <- <SmoothDistanceAttenuation_id103 return value>

#line 403
  mul r3.x, r3.x, r4.w  // r3.x <- attenuation

#line 394
  dp3 r4.w, -r8.xyzx, r5.xyzx  // r4.w <- cd

#line 395
  mad_sat r4.w, r4.w, r9.x, r9.y  // r4.w <- attenuation

#line 396
  mul r4.w, r4.w, r4.w

#line 518
  mul r3.x, r3.x, r4.w  // r3.x <- attenuation

#line 840
  dp3 r4.w, r2.xyzx, r5.xyzx
  max r4.w, r4.w, l(0.000100)  // r4.w <- streams.NdotL_id49

#line 842
  mul r5.xyz, r3.xxxx, r7.yzwy
  mul r5.xyz, r4.wwww, r5.xyzx  // r5.x <- streams.lightColorNdotL_id44.x; r5.y <- streams.lightColorNdotL_id44.y; r5.z <- streams.lightColorNdotL_id44.z

#line 907
  mul r5.xyz, r0.yzwy, r5.xyzx

#line 1063
  mad r4.xyz, r5.xyzx, l(0.318310, 0.318310, 0.318310, 0.000000), r4.xyzx

#line 1053
  iadd r3.w, r3.w, l(1)

#line 1065
endloop   // r1.w <- streams.lightIndex_id196

#line 828
mul r0.xyz, cb1[0].xyzx, cb2[149].xyzx  // r0.x <- <ComputeEnvironmentLightContribution_id213 return value>.x; r0.y <- <ComputeEnvironmentLightContribution_id213 return value>.y; r0.z <- <ComputeEnvironmentLightContribution_id213 return value>.z

#line 1084
mad o0.xyz, r4.xyzx, l(3.141593, 3.141593, 3.141593, 0.000000), r0.xyzx

#line 1164
utof o1.xyzw, cb0[26].xxxx

#line 1232
mov o0.w, cb1[0].w
ret 
// Approximately 317 instruction slots used
***************************
*************************/
const static int TMaxLightCount_id87 = 1;
const static int TCascadeCountBase_id151 = 4;
const static int TLightCountBase_id152 = 1;
const static int TCascadeCount_id159 = 4;
const static int TLightCount_id160 = 1;
const static bool TBlendCascades_id161 = true;
const static bool TDepthRangeAuto_id162 = true;
const static bool TCascadeDebug_id163 = false;
const static bool TComputeTransmittance_id164 = false;
const static int TFilterSize_id188 = 5;
static const float PI_id208 = 3.14159265358979323846;
const static bool TIsEnergyConservative_id209 = false;
struct PS_STREAMS 
{
    float4 ScreenPosition_id189;
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
    uint2 lightData_id195;
    int lightIndex_id196;
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
    float4 ScreenPosition_id189 : SCREENPOSITION_ID189_SEM;
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
    float4 ScreenPosition_id189;
};
struct VS_OUTPUT 
{
    float4 PositionWS_id22 : POSITION_WS;
    float4 ShadingPosition_id0 : SV_Position;
    float DepthVS_id23 : DEPTH_VS;
    float3 normalWS_id19 : NORMALWS;
    float4 ScreenPosition_id189 : SCREENPOSITION_ID189_SEM;
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
    float4 constantColor_id205;
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
    float NearClipPlane_id190 = 1.0f;
    float FarClipPlane_id191 = 100.0f;
    float2 ZProjection_id192;
    float2 ViewSize_id193;
    float AspectRatio_id194;
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
    int LightCount_id166;
    DirectionalLightData Lights_id168[TMaxLightCount_id87];
    float2 ShadowMapTextureSize_id170;
    float2 ShadowMapTextureTexelSize_id171;
    float4x4 WorldToShadowCascadeUV_id175[TCascadeCountBase_id151 * TLightCountBase_id152];
    float4x4 InverseWorldToShadowCascadeUV_id176[TCascadeCountBase_id151 * TLightCountBase_id152];
    float4x4 ViewMatrices_id177[TCascadeCountBase_id151 * TLightCountBase_id152];
    float2 DepthRanges_id178[TCascadeCountBase_id151 * TLightCountBase_id152];
    float DepthBiases_id179[TLightCountBase_id152];
    float OffsetScales_id180[TLightCountBase_id152];
    float CascadeDepthSplits_id187[TCascadeCount_id159 * TLightCount_id160];
    float ClusterDepthScale_id199;
    float ClusterDepthBias_id200;
    float2 ClusterStride_id201;
    float3 AmbientLight_id204;
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
Texture2D ShadowMapTexture_id169;
Texture3D<uint2> LightClusters_id197;
Buffer<uint> LightIndices_id198;
Buffer<float4> PointLights_id202;
Buffer<float4> SpotLights_id203;
float4 Project_id70(float4 vec, float4x4 mat)
{
    float4 vecProjected = mul(vec, mat);
    vecProjected.xyz /= vecProjected.w;
    return vecProjected;
}
float SmoothDistanceAttenuation_id103(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float SmoothDistanceAttenuation_id92(float squaredDistance, float lightInvSquareRadius)
{
    float factor = squaredDistance * lightInvSquareRadius;
    float smoothFactor = saturate(1.0f - factor * factor);
    return smoothFactor * smoothFactor;
}
float Get3x3FilterKernel_id80(float2 base_uv, float2 st, out float3 kernel[4])
{
    float2 uvW0 = (3 - 2 * st);
    float2 uvW1 = (1 + 2 * st);
    float2 uv0 = (2 - st) / uvW0 - 1;
    float2 uv1 = st / uvW1 + 1;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id171, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id171, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id171, uvW0.x * uvW1.y);
    kernel[3] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id171, uvW1.x * uvW1.y);
    return 16.0;
}
float Get5x5FilterKernel_id79(float2 base_uv, float2 st, out float3 kernel[9])
{
    float2 uvW0 = (4 - 3 * st);
    float2 uvW1 = 7;
    float2 uvW2 = (1 + 3 * st);
    float2 uv0 = (3 - 2 * st) / uvW0 - 2;
    float2 uv1 = (3 + st) / uvW1;
    float2 uv2 = st / uvW2 + 2;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id171, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id171, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv2.x, uv0.y) * ShadowMapTextureTexelSize_id171, uvW2.x * uvW0.y);
    kernel[3] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id171, uvW0.x * uvW1.y);
    kernel[4] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id171, uvW1.x * uvW1.y);
    kernel[5] = float3(base_uv + float2(uv2.x, uv1.y) * ShadowMapTextureTexelSize_id171, uvW2.x * uvW1.y);
    kernel[6] = float3(base_uv + float2(uv0.x, uv2.y) * ShadowMapTextureTexelSize_id171, uvW0.x * uvW2.y);
    kernel[7] = float3(base_uv + float2(uv1.x, uv2.y) * ShadowMapTextureTexelSize_id171, uvW1.x * uvW2.y);
    kernel[8] = float3(base_uv + uv2 * ShadowMapTextureTexelSize_id171, uvW2.x * uvW2.y);
    return 144.0;
}
float SampleThickness_id81(float3 shadowSpaceCoordinate, float3 pixelPositionWS, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float shadowMapDepth = ShadowMapTexture_id169.SampleLevel(LinearBorderSampler_id123, shadowSpaceCoordinate.xy, 0).r;
    float thickness;
    if (isOrthographic)
    {
        thickness = abs(shadowMapDepth - shadowSpaceCoordinate.z) * depthRanges.y;
    }
    else
    {
        float4 shadowmapPositionWorldSpace = Project_id70(float4(shadowSpaceCoordinate.xy, shadowMapDepth, 1.0), inverseWorldToShadowCascadeUV);
        thickness = distance(shadowmapPositionWorldSpace.xyz, pixelPositionWS.xyz);
    }
    return (thickness);
}
float Get7x7FilterKernel_id77(float2 base_uv, float2 st, out float3 kernel[16])
{
    float2 uvW0 = (5 * st - 6);
    float2 uvW1 = (11 * st - 28);
    float2 uvW2 = -(11 * st + 17);
    float2 uvW3 = -(5 * st + 1);
    float2 uv0 = (4 * st - 5) / uvW0 - 3;
    float2 uv1 = (4 * st - 16) / uvW1 - 1;
    float2 uv2 = -(7 * st + 5) / uvW2 + 1;
    float2 uv3 = -st / uvW3 + 3;
    kernel[0] = float3(base_uv + uv0 * ShadowMapTextureTexelSize_id171, uvW0.x * uvW0.y);
    kernel[1] = float3(base_uv + float2(uv1.x, uv0.y) * ShadowMapTextureTexelSize_id171, uvW1.x * uvW0.y);
    kernel[2] = float3(base_uv + float2(uv2.x, uv0.y) * ShadowMapTextureTexelSize_id171, uvW2.x * uvW0.y);
    kernel[3] = float3(base_uv + float2(uv3.x, uv0.y) * ShadowMapTextureTexelSize_id171, uvW3.x * uvW0.y);
    kernel[4] = float3(base_uv + float2(uv0.x, uv1.y) * ShadowMapTextureTexelSize_id171, uvW0.x * uvW1.y);
    kernel[5] = float3(base_uv + uv1 * ShadowMapTextureTexelSize_id171, uvW1.x * uvW1.y);
    kernel[6] = float3(base_uv + float2(uv2.x, uv1.y) * ShadowMapTextureTexelSize_id171, uvW2.x * uvW1.y);
    kernel[7] = float3(base_uv + float2(uv3.x, uv1.y) * ShadowMapTextureTexelSize_id171, uvW3.x * uvW1.y);
    kernel[8] = float3(base_uv + float2(uv0.x, uv2.y) * ShadowMapTextureTexelSize_id171, uvW0.x * uvW2.y);
    kernel[9] = float3(base_uv + float2(uv1.x, uv2.y) * ShadowMapTextureTexelSize_id171, uvW1.x * uvW2.y);
    kernel[10] = float3(base_uv + uv2 * ShadowMapTextureTexelSize_id171, uvW2.x * uvW2.y);
    kernel[11] = float3(base_uv + float2(uv3.x, uv2.y) * ShadowMapTextureTexelSize_id171, uvW3.x * uvW2.y);
    kernel[12] = float3(base_uv + float2(uv0.x, uv3.y) * ShadowMapTextureTexelSize_id171, uvW0.x * uvW3.y);
    kernel[13] = float3(base_uv + float2(uv1.x, uv3.y) * ShadowMapTextureTexelSize_id171, uvW1.x * uvW3.y);
    kernel[14] = float3(base_uv + float2(uv2.x, uv3.y) * ShadowMapTextureTexelSize_id171, uvW2.x * uvW3.y);
    kernel[15] = float3(base_uv + uv3 * ShadowMapTextureTexelSize_id171, uvW3.x * uvW3.y);
    return 2704.0;
}
float4 Project_id53(float4 vec, float4x4 mat)
{
    float4 vecProjected = mul(vec, mat);
    vecProjected.xyz /= vecProjected.w;
    return vecProjected;
}
float GetAngularAttenuation_id105(float3 lightVector, float3 lightDirection, float lightAngleScale, float lightAngleOffset)
{
    float cd = dot(lightDirection, lightVector);
    float attenuation = saturate(cd * lightAngleScale + lightAngleOffset);
    attenuation *= attenuation;
    return attenuation;
}
float GetDistanceAttenuation_id104(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id103(d2, lightInvSquareRadius);
    return attenuation;
}
float GetDistanceAttenuation_id94(float lightVectorLength, float lightInvSquareRadius)
{
    float d2 = lightVectorLength * lightVectorLength;
    float attenuation = 1.0 / (max(d2, 0.01 * 0.01));
    attenuation *= SmoothDistanceAttenuation_id92(d2, lightInvSquareRadius);
    return attenuation;
}
float SampleAndFilter_id85(float3 adjustedPixelPositionWS, float3 adjustedPixelPositionShadowSpace, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic, bool isDualParaboloid = false)
{
    float2 uv = adjustedPixelPositionShadowSpace.xy * ShadowMapTextureSize_id170;
    float2 base_uv = floor(uv + 0.5);
    float2 st = uv + 0.5 - base_uv;
    base_uv *= ShadowMapTextureTexelSize_id171;
    float thickness = 0.0;
    float normalizationFactor = 1.0;

    {
        float3 kernel[9];
        normalizationFactor = Get5x5FilterKernel_id79(base_uv, st, kernel);

        [unroll]
        for (int i = 0; i < 9; ++i)
        {
            thickness += kernel[i].z * SampleThickness_id81(float3(kernel[i].xy, adjustedPixelPositionShadowSpace.z), adjustedPixelPositionWS, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
        }
    }
    return (thickness / normalizationFactor);
}
void CalculateAdjustedShadowSpacePixelPosition_id84(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    float4 bottomLeftTexelWS = Project_id70(float4(0.0, 0.0, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id70(float4(ShadowMapTextureTexelSize_id171.xy * filterRadiusInPixels, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, bottomLeftTexelWS.xyz);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 shadowMapCoordinate = Project_id70(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = shadowMapCoordinate.xyz;
}
void CalculateAdjustedShadowSpacePixelPositionPerspective_id83(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    const float4 shadowMapCoordinate = Project_id70(float4(pixelPositionWS, 1.0), worldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id70(float4(shadowMapCoordinate.xy + ShadowMapTextureTexelSize_id171.xy * filterRadiusInPixels, shadowMapCoordinate.z, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, pixelPositionWS);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 adjustedShadowMapCoordinate = Project_id70(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = adjustedShadowMapCoordinate.xyz;
}
float GetFilterRadiusInPixels_id82()
{

    {
        return 3.5;
    }
}
float SampleTextureAndCompare_id78(float2 position, float positionDepth)
{
    return ShadowMapTexture_id169.SampleCmpLevelZero(LinearClampCompareLessEqualSampler_id124, position, positionDepth);
}
void CalculatePCFKernelParameters_id76(float2 position, out float2 base_uv, out float2 st)
{
    float2 uv = position * ShadowMapTextureSize_id170;
    base_uv = floor(uv + 0.5);
    st = uv + 0.5 - base_uv;
    base_uv -= 0.5;
    base_uv *= ShadowMapTextureTexelSize_id171;
}
float SampleThickness_id61(float3 shadowSpaceCoordinate, float3 pixelPositionWS, float2 depthRanges, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float shadowMapDepth = ShadowMapTexture_id89.SampleLevel(LinearBorderSampler_id123, shadowSpaceCoordinate.xy, 0).r;
    float thickness;
    if (isOrthographic)
    {
        thickness = abs(shadowMapDepth - shadowSpaceCoordinate.z) * depthRanges.y;
    }
    else
    {
        float4 shadowmapPositionWorldSpace = Project_id53(float4(shadowSpaceCoordinate.xy, shadowMapDepth, 1.0), inverseWorldToShadowCascadeUV);
        thickness = distance(shadowmapPositionWorldSpace.xyz, pixelPositionWS.xyz);
    }
    return (thickness);
}
void CalculateAdjustedShadowSpacePixelPosition_id60(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    float4 bottomLeftTexelWS = Project_id53(float4(0.0, 0.0, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id53(float4(ShadowMapTextureTexelSize_id91.xy * filterRadiusInPixels, 0.0, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, bottomLeftTexelWS.xyz);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 shadowMapCoordinate = Project_id53(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = shadowMapCoordinate.xyz;
}
void CalculateAdjustedShadowSpacePixelPositionPerspective_id59(float filterRadiusInPixels, float3 pixelPositionWS, float3 meshNormalWS, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, out float3 adjustedPixelPositionWS, out float3 adjustedPixelPositionShadowSpace)
{
    const float4 shadowMapCoordinate = Project_id53(float4(pixelPositionWS, 1.0), worldToShadowCascadeUV);
    const float4 topRightTexelWS = Project_id53(float4(shadowMapCoordinate.xy + ShadowMapTextureTexelSize_id91.xy * filterRadiusInPixels, shadowMapCoordinate.z, 1.0), inverseWorldToShadowCascadeUV);
    const float texelDiagonalLength = distance(topRightTexelWS.xyz, pixelPositionWS);
    const float3 positionOffsetWS = meshNormalWS * texelDiagonalLength;
    adjustedPixelPositionWS = pixelPositionWS - positionOffsetWS;
    const float4 adjustedShadowMapCoordinate = Project_id53(float4(adjustedPixelPositionWS, 1.0), worldToShadowCascadeUV);
    adjustedPixelPositionShadowSpace = adjustedShadowMapCoordinate.xyz;
}
float ComputeAttenuation_id106(float3 PositionWS, float3 AngleOffsetAndInvSquareRadius, float3 DirectionWS, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float3 lightAngleOffsetAndInvSquareRadius = AngleOffsetAndInvSquareRadius;
    float2 lightAngleAndOffset = lightAngleOffsetAndInvSquareRadius.xy;
    float lightInvSquareRadius = lightAngleOffsetAndInvSquareRadius.z;
    float3 lightDirection = -DirectionWS;
    float attenuation = GetDistanceAttenuation_id104(lightVectorLength, lightInvSquareRadius);
    attenuation *= GetAngularAttenuation_id105(lightVectorNorm, lightDirection, lightAngleAndOffset.x, lightAngleAndOffset.y);
    return attenuation;
}
float ComputeAttenuation_id93(PointLightDataInternal light, float3 position, inout float3 lightVectorNorm)
{
    float3 lightVector = light.PositionWS - position;
    float lightVectorLength = length(lightVector);
    lightVectorNorm = lightVector / lightVectorLength;
    float lightInvSquareRadius = light.InvSquareRadius;
    return GetDistanceAttenuation_id94(lightVectorLength, lightInvSquareRadius);
}
float FilterThickness_id72(float3 pixelPositionWS, float3 meshNormalWS, float2 depthRanges, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    float3 adjustedPixelPositionWS;
    float3 adjustedPixelPositionShadowSpace;
    if (isOrthographic)
    {
        CalculateAdjustedShadowSpacePixelPosition_id84(GetFilterRadiusInPixels_id82(), pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    else
    {
        CalculateAdjustedShadowSpacePixelPositionPerspective_id83(GetFilterRadiusInPixels_id82(), pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    return SampleAndFilter_id85(adjustedPixelPositionWS, adjustedPixelPositionShadowSpace, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
}
float FilterShadow_id71(float2 position, float positionDepth)
{
    float shadow = 0.0f;
    float2 base_uv;
    float2 st;
    CalculatePCFKernelParameters_id76(position, base_uv, st);

    {
        float3 kernel[9];
        float normalizationFactor = Get5x5FilterKernel_id79(base_uv, st, kernel);

        [unroll]
        for (int i = 0; i < 9; ++i)
        {
            shadow += kernel[i].z * SampleTextureAndCompare_id78(kernel[i].xy, positionDepth);
        }
        shadow /= normalizationFactor;
    }
    return shadow;
}
float FilterThickness_id55(float3 pixelPositionWS, float3 meshNormalWS, float2 depthRanges, float4x4 worldToShadowCascadeUV, float4x4 inverseWorldToShadowCascadeUV, bool isOrthographic)
{
    const float filterRadiusInPixels = 1.5;
    float3 adjustedPixelPositionWS;
    float3 adjustedPixelPositionShadowSpace;
    if (isOrthographic)
    {
        CalculateAdjustedShadowSpacePixelPosition_id60(filterRadiusInPixels, pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    else
    {
        CalculateAdjustedShadowSpacePixelPositionPerspective_id59(filterRadiusInPixels, pixelPositionWS, meshNormalWS, worldToShadowCascadeUV, inverseWorldToShadowCascadeUV, adjustedPixelPositionWS, adjustedPixelPositionShadowSpace);
    }
    return SampleThickness_id61(adjustedPixelPositionShadowSpace, adjustedPixelPositionWS, depthRanges, inverseWorldToShadowCascadeUV, isOrthographic);
}
float FilterShadow_id54(float2 position, float positionDepth)
{
    return ShadowMapTexture_id89.SampleCmpLevelZero(LinearClampCompareLessEqualSampler_id124, position, positionDepth);
}
void ProcessLight_id107(inout PS_STREAMS streams, SpotLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id106(light.PositionWS, light.AngleOffsetAndInvSquareRadius, light.DirectionWS, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
void ProcessLight_id96(inout PS_STREAMS streams, PointLightDataInternal light)
{
    float3 lightVectorNorm;
    float attenuation = ComputeAttenuation_id93(light, streams.PositionWS_id22.xyz, lightVectorNorm);
    streams.lightPositionWS_id41 = light.PositionWS;
    streams.lightColor_id43 = light.Color;
    streams.lightAttenuation_id46 = attenuation;
    streams.lightDirectionWS_id42 = lightVectorNorm;
}
float ComputeThicknessFromCascade_id75(float3 pixelPositionWS, float3 meshNormalWS, int cascadeIndex, int lightIndex, bool isOrthographic)
{
    const int arrayIndex = cascadeIndex + lightIndex * TCascadeCountBase_id151;
    return FilterThickness_id72(pixelPositionWS, meshNormalWS, DepthRanges_id178[arrayIndex], WorldToShadowCascadeUV_id175[arrayIndex], InverseWorldToShadowCascadeUV_id176[arrayIndex], isOrthographic);
}
float ComputeShadowFromCascade_id74(float3 shadowPositionWS, int cascadeIndex, int lightIndex)
{
    float4 shadowPosition = mul(float4(shadowPositionWS, 1.0), WorldToShadowCascadeUV_id175[cascadeIndex + lightIndex * TCascadeCountBase_id151]);
    shadowPosition.z -= DepthBiases_id179[lightIndex];
    shadowPosition.xyz /= shadowPosition.w;
    return FilterShadow_id71(shadowPosition.xy, shadowPosition.z);
}
float3 GetShadowPositionOffset_id73(float offsetScale, float nDotL, float3 normal)
{
    float normalOffsetScale = saturate(1.0f - nDotL);
    return 2.0f * ShadowMapTextureTexelSize_id171.x * offsetScale * normalOffsetScale * normal;
}
float ComputeThicknessFromCascade_id58(float3 pixelPositionWS, float3 meshNormalWS, int cascadeIndex, int lightIndex, bool isOrthographic)
{
    const int arrayIndex = cascadeIndex + lightIndex * TCascadeCountBase_id151;
    return FilterThickness_id55(pixelPositionWS, meshNormalWS, DepthRanges_id156[arrayIndex], WorldToShadowCascadeUV_id153[arrayIndex], InverseWorldToShadowCascadeUV_id154[arrayIndex], isOrthographic);
}
float ComputeShadowFromCascade_id57(float3 shadowPositionWS, int cascadeIndex, int lightIndex)
{
    float4 shadowPosition = mul(float4(shadowPositionWS, 1.0), WorldToShadowCascadeUV_id153[cascadeIndex + lightIndex * TCascadeCountBase_id151]);
    shadowPosition.z -= DepthBiases_id157[lightIndex];
    shadowPosition.xyz /= shadowPosition.w;
    return FilterShadow_id54(shadowPosition.xy, shadowPosition.z);
}
float3 GetShadowPositionOffset_id56(float offsetScale, float nDotL, float3 normal)
{
    float normalOffsetScale = saturate(1.0f - nDotL);
    return 2.0f * ShadowMapTextureTexelSize_id91.x * offsetScale * normalOffsetScale * normal;
}
void PrepareEnvironmentLight_id111(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeSpecularTextureProjection_id102(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id101(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id100(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id99(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id198.Load(streams.lightIndex_id196);
    streams.lightIndex_id196++;
    SpotLightDataInternal spotLight;
    float4 spotLight1 = SpotLights_id203.Load(realLightIndex * 4);
    float4 spotLight2 = SpotLights_id203.Load(realLightIndex * 4 + 1);
    float4 spotLight3 = SpotLights_id203.Load(realLightIndex * 4 + 2);
    float4 spotLight4 = SpotLights_id203.Load(realLightIndex * 4 + 3);
    spotLight.PositionWS = spotLight1.xyz;
    spotLight.DirectionWS = spotLight2.xyz;
    spotLight.AngleOffsetAndInvSquareRadius = spotLight3.xyz;
    spotLight.Color = spotLight4.xyz;
    ProcessLight_id107(streams, spotLight);
}
float3 ComputeSpecularTextureProjection_id91(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id90(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id89(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    streams.thicknessWS_id85 = 0.0;
    return 1.0f;
}
void PrepareDirectLightCore_id88(inout PS_STREAMS streams, int lightIndexIgnored)
{
    int realLightIndex = LightIndices_id198.Load(streams.lightIndex_id196);
    streams.lightIndex_id196++;
    PointLightDataInternal pointLight;
    float4 pointLight1 = PointLights_id202.Load(realLightIndex * 2);
    float4 pointLight2 = PointLights_id202.Load(realLightIndex * 2 + 1);
    pointLight.PositionWS = pointLight1.xyz;
    pointLight.InvSquareRadius = pointLight1.w;
    pointLight.Color = pointLight2.xyz;
    ProcessLight_id96(streams, pointLight);
}
void PrepareLightData_id95(inout PS_STREAMS streams)
{
    float projectedDepth = streams.ShadingPosition_id0.z;
    float depth = ZProjection_id192.y / (projectedDepth - ZProjection_id192.x);
    float2 texCoord = float2(streams.ScreenPosition_id189.x + 1, 1 - streams.ScreenPosition_id189.y) * 0.5;
    int slice = int(max(log2(depth * ClusterDepthScale_id199 + ClusterDepthBias_id200), 0));
    streams.lightData_id195 = LightClusters_id197.Load(int4(texCoord * ClusterStride_id201, slice, 0));
    streams.lightIndex_id196 = streams.lightData_id195.x;
}
float3 ComputeSpecularTextureProjection_id67(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id66(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id65(inout PS_STREAMS streams, float3 position, int lightIndex)
{
    int cascadeIndexBase = lightIndex * TCascadeCount_id159;
    int cascadeIndex = 0;

    [unroll]
    for (int i = 0; i < TCascadeCount_id159 - 1; i++)
    {
        [flatten]
        if (streams.DepthVS_id23 > CascadeDepthSplits_id187[cascadeIndexBase + i])
        {
            cascadeIndex = i + 1;
        }
    }
    float3 shadow = 1.0;
    float tempThickness = 999.0;
    float3 shadowPosition = position.xyz;
    shadowPosition += GetShadowPositionOffset_id73(OffsetScales_id180[lightIndex], streams.NdotL_id49, streams.normalWS_id19);
    if (cascadeIndex < TCascadeCount_id159)
    {
        shadow = ComputeShadowFromCascade_id74(shadowPosition, cascadeIndex, lightIndex);
        float nextSplit = CascadeDepthSplits_id187[cascadeIndexBase + cascadeIndex];
        float splitSize = nextSplit;
        if (cascadeIndex > 0)
        {
            splitSize = nextSplit - CascadeDepthSplits_id187[cascadeIndexBase + cascadeIndex - 1];
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
                float nextShadow = ComputeShadowFromCascade_id74(shadowPosition, cascadeIndex + 1, lightIndex);
                shadow = lerp(nextShadow, shadow, lerpAmt);
            }
        }
    }
    streams.thicknessWS_id85 = tempThickness;
    return shadow;
}
void PrepareDirectLightCore_id64(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id168[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id168[lightIndex].DirectionWS;
}
float3 ComputeSpecularTextureProjection_id50(float3 positionWS, float3 reflectionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeTextureProjection_id49(float3 positionWS, int lightIndex)
{
    return 1.0f;
}
float3 ComputeShadow_id48(inout PS_STREAMS streams, float3 position, int lightIndex)
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
    shadowPosition += GetShadowPositionOffset_id56(OffsetScales_id158[lightIndex], streams.NdotL_id49, streams.normalWS_id19);
    if (cascadeIndex < TCascadeCount_id159)
    {
        shadow = ComputeShadowFromCascade_id57(shadowPosition, cascadeIndex, lightIndex);
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
                float nextShadow = ComputeShadowFromCascade_id57(shadowPosition, cascadeIndex + 1, lightIndex);
                shadow = lerp(nextShadow, shadow, lerpAmt);
            }
        }
    }
    streams.thicknessWS_id85 = tempThickness;
    return shadow;
}
void PrepareDirectLightCore_id47(inout PS_STREAMS streams, int lightIndex)
{
    streams.lightColor_id43 = Lights_id88[lightIndex].Color;
    streams.lightDirectionWS_id42 = -Lights_id88[lightIndex].DirectionWS;
}
void ResetStream_id126()
{
}
void AfterLightingAndShading_id220()
{
}
void PrepareEnvironmentLight_id209(inout PS_STREAMS streams)
{
    streams.envLightDiffuseColor_id47 = 0;
    streams.envLightSpecularColor_id48 = 0;
}
float3 ComputeEnvironmentLightContribution_id213(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor * streams.envLightDiffuseColor_id47;
}
void PrepareEnvironmentLight_id206(inout PS_STREAMS streams)
{
    PrepareEnvironmentLight_id111(streams);
    float3 lightColor = AmbientLight_id204 * streams.matAmbientOcclusion_id57;
    streams.envLightDiffuseColor_id47 = lightColor;
    streams.envLightSpecularColor_id48 = lightColor;
}
void PrepareDirectLight_id197(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id99(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id100(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id101(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id102(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id201(inout PS_STREAMS streams)
{
    return streams.lightData_id195.y >> 16;
}
int GetMaxLightCount_id200(inout PS_STREAMS streams)
{
    return streams.lightData_id195.y >> 16;
}
void PrepareDirectLights_id195()
{
}
void PrepareDirectLight_id184(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id88(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id89(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id90(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id91(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id189(inout PS_STREAMS streams)
{
    return streams.lightData_id195.y & 0xFFFF;
}
int GetMaxLightCount_id188(inout PS_STREAMS streams)
{
    return streams.lightData_id195.y & 0xFFFF;
}
void PrepareDirectLights_id187(inout PS_STREAMS streams)
{
    PrepareLightData_id95(streams);
}
void PrepareDirectLight_id160(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id64(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id65(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id66(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id67(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id162()
{
    return LightCount_id166;
}
int GetMaxLightCount_id163()
{
    return TMaxLightCount_id87;
}
void PrepareDirectLights_id158()
{
}
float3 ComputeDirectLightContribution_id212(inout PS_STREAMS streams)
{
    float3 diffuseColor = streams.matDiffuseVisible_id69;
    return diffuseColor / PI_id208 * streams.lightColorNdotL_id44 * streams.matDiffuseSpecularAlphaBlend_id65.x;
}
void PrepareMaterialPerDirectLight_id30(inout PS_STREAMS streams)
{
    streams.H_id75 = normalize(streams.viewWS_id68 + streams.lightDirectionWS_id42);
    streams.NdotH_id76 = saturate(dot(streams.normalWS_id19, streams.H_id75));
    streams.LdotH_id77 = saturate(dot(streams.lightDirectionWS_id42, streams.H_id75));
    streams.VdotH_id78 = streams.LdotH_id77;
}
void PrepareDirectLight_id136(inout PS_STREAMS streams, int lightIndex)
{
    PrepareDirectLightCore_id47(streams, lightIndex);
    streams.NdotL_id49 = max(dot(streams.normalWS_id19, streams.lightDirectionWS_id42), 0.0001f);
    streams.shadowColor_id84 = ComputeShadow_id48(streams, streams.PositionWS_id22.xyz, lightIndex);
    streams.lightColorNdotL_id44 = streams.lightColor_id43 * streams.lightAttenuation_id46 * streams.shadowColor_id84 * streams.NdotL_id49 * streams.lightDirectAmbientOcclusion_id50;
    streams.lightSpecularColorNdotL_id45 = streams.lightColorNdotL_id44;
    streams.lightColorNdotL_id44 *= ComputeTextureProjection_id49(streams.PositionWS_id22.xyz, lightIndex);
    float3 reflectionVectorWS = reflect(-streams.viewWS_id68, streams.normalWS_id19);
    streams.lightSpecularColorNdotL_id45 *= ComputeSpecularTextureProjection_id50(streams.PositionWS_id22.xyz, reflectionVectorWS, lightIndex);
}
int GetLightCount_id138()
{
    return LightCount_id86;
}
int GetMaxLightCount_id139()
{
    return TMaxLightCount_id87;
}
void PrepareDirectLights_id134()
{
}
void PrepareForLightingAndShading_id217()
{
}
void PrepareMaterialForLightingAndShading_id125(inout PS_STREAMS streams)
{
    streams.lightDirectAmbientOcclusion_id50 = lerp(1.0, streams.matAmbientOcclusion_id57, streams.matAmbientOcclusionDirectLightingFactor_id58);
    streams.matDiffuseVisible_id69 = streams.matDiffuse_id53.rgb * lerp(1.0f, streams.matCavity_id59, streams.matCavityDiffuse_id60) * streams.matDiffuseSpecularAlphaBlend_id65.r * streams.matAlphaBlendColor_id66;
    streams.matSpecularVisible_id71 = streams.matSpecular_id55.rgb * streams.matSpecularIntensity_id56 * lerp(1.0f, streams.matCavity_id59, streams.matCavitySpecular_id61) * streams.matDiffuseSpecularAlphaBlend_id65.g * streams.matAlphaBlendColor_id66;
    streams.NdotV_id72 = max(dot(streams.normalWS_id19, streams.viewWS_id68), 0.0001f);
    float roughness = 1.0f - streams.matGlossiness_id54;
    streams.alphaRoughness_id70 = max(roughness * roughness, 0.001);
}
void ResetLightStream_id124(inout PS_STREAMS streams)
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
float4 Compute_id210()
{
    return constantColor_id205;
}
void ResetStream_id127(inout PS_STREAMS streams)
{
    ResetStream_id126();
    streams.matBlend_id40 = 0.0f;
}
void Compute_id254(inout PS_STREAMS streams)
{
    UpdateNormalFromTangentSpace_id23(streams.matNormal_id51);
    if (!streams.IsFrontFace_id1)
        streams.normalWS_id19 = -streams.normalWS_id19;
    ResetLightStream_id124(streams);
    PrepareMaterialForLightingAndShading_id125(streams);

    {
        PrepareForLightingAndShading_id217();
    }
    float3 directLightingContribution = 0;

    {
        PrepareDirectLights_id134();
        const int maxLightCount = GetMaxLightCount_id139();
        int count = GetLightCount_id138();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id136(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id212(streams);
            }
        }
    }

    {
        PrepareDirectLights_id158();
        const int maxLightCount = GetMaxLightCount_id163();
        int count = GetLightCount_id162();

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id160(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id212(streams);
            }
        }
    }

    {
        PrepareDirectLights_id187(streams);
        const int maxLightCount = GetMaxLightCount_id188(streams);
        int count = GetLightCount_id189(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id184(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id212(streams);
            }
        }
    }

    {
        PrepareDirectLights_id195();
        const int maxLightCount = GetMaxLightCount_id200(streams);
        int count = GetLightCount_id201(streams);

        for (int i = 0; i < maxLightCount; i++)
        {
            if (i >= count)
            {
                break;
            }
            PrepareDirectLight_id197(streams, i);
            PrepareMaterialPerDirectLight_id30(streams);

            {
                directLightingContribution += ComputeDirectLightContribution_id212(streams);
            }
        }
    }
    float3 environmentLightingContribution = 0;

    {
        PrepareEnvironmentLight_id206(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id213(streams);
        }
    }

    {
        PrepareEnvironmentLight_id209(streams);

        {
            environmentLightingContribution += ComputeEnvironmentLightContribution_id213(streams);
        }
    }
    streams.shadingColor_id73 += directLightingContribution * PI_id208 + environmentLightingContribution;
    streams.shadingColorAlpha_id74 = streams.matDiffuse_id53.a;

    {
        AfterLightingAndShading_id220();
    }
}
void Compute_id238(inout PS_STREAMS streams)
{
    float4 colorBase = Compute_id210();
    streams.matDiffuse_id53 = colorBase;
    streams.matColorBase_id52 = colorBase;
}
void ResetStream_id128(inout PS_STREAMS streams)
{
    ResetStream_id127(streams);
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
void Compute_id44(inout PS_STREAMS streams)
{

    {
        Compute_id238(streams);
    }

    {
        Compute_id254(streams);
    }
}
void ResetStream_id43(inout PS_STREAMS streams)
{
    ResetStream_id128(streams);
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
float4 Compute_id42()
{
    return MaterialIndex_id83;
}
float4 Shading_id31(inout PS_STREAMS streams)
{
    streams.viewWS_id68 = normalize(Eye_id31.xyz - streams.PositionWS_id22.xyz);
    streams.shadingColor_id73 = 0;
    ResetStream_id43(streams);
    Compute_id44(streams);
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
    streams.ColorTarget1_id3 = Compute_id42();
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
    streams.ScreenPosition_id189 = __input__.ScreenPosition_id189;
    streams.IsFrontFace_id1 = __input__.IsFrontFace_id1;
    streams.ScreenPosition_id189 /= streams.ScreenPosition_id189.w;
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
    streams.ScreenPosition_id189 = streams.ShadingPosition_id0;
    VS_OUTPUT __output__ = (VS_OUTPUT)0;
    __output__.PositionWS_id22 = streams.PositionWS_id22;
    __output__.ShadingPosition_id0 = streams.ShadingPosition_id0;
    __output__.DepthVS_id23 = streams.DepthVS_id23;
    __output__.normalWS_id19 = streams.normalWS_id19;
    __output__.ScreenPosition_id189 = streams.ScreenPosition_id189;
    return __output__;
}
