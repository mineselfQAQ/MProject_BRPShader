Shader "MineselfShader/Advance/1-ToonWater/ToonWater"
{
    Properties
    {
        [Header(Color)][Space(5)]
        _ShallowCol("ShallowColor", COLOR) = (1,1,1,1)
        _DepthCol("DepthColor", COLOR) = (0,0,0,0)
        _FoamCol("FoamColor", COLOR) = (1,1,1,1)
        _EdgeDistance("EdgeDistance", Float) = 1
        
        [Header(Foam)][Space(5)]
        _NoiseTex("NoiseTexture", 2D) = "white"{}
        _DistortTex("DistortTexture", 2D) = "white"{}
        _DistortInt("DistortIntensity", Range(0, 1)) = 0.1 
        [Space(5)]
        _FoamSpeed("FoamSpeed", vector) = (1,1,0,0)
        _FoamSmooth("FoamSmooth", Range(0, 0.1)) = 0.02
        _SmallFoamSize("SamllFoamSize", Float) = 1
        _FoamDistance("_FoamDistance", vector) = (0,0,0,0)

    }
    SubShader
    {
        //SubShader Tags
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
            #include "..\..\_Common\MyLib.cginc"

			
            //变量申明
            sampler2D _CameraDepthTexture;
            sampler2D _CameraDepthNormalTexture;
            
            fixed4 _ShallowCol;
            fixed4 _DepthCol;
            fixed4 _FoamCol;
            float _EdgeDistance;

            sampler2D _NoiseTex; float4 _NoiseTex_ST;
            sampler2D _DistortTex; float4 _DistortTex_ST;
            float _DistortInt;
            float2 _FoamSpeed;
            float _FoamSmooth;
            float _FoamWidth;
            float _SmallFoamSize;
            float2 _FoamDistance;

			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenPos : TEXCOORD0;
                float2 distortUV : TEXCOORD1;
                float2 noiseUV : TEXCOORD2;
                float3 vNormal : TEXCOORD3;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.distortUV = TRANSFORM_TEX(v.uv, _DistortTex);
                o.noiseUV = TRANSFORM_TEX(v.uv, _NoiseTex);

                o.screenPos = ComputeScreenPos(o.pos);

                //获得自己的观察空间法线
                o.vNormal = COMPUTE_VIEW_NORMAL;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //计算深度法线图
                float3 depthNormal = tex2Dproj(_CameraDepthNormalTexture, UNITY_PROJ_COORD(i.screenPos));
                float normalDot = saturate(dot(depthNormal, i.vNormal));
                float foamDistance = lerp(_FoamDistance.y, _FoamDistance.x, normalDot);

                //使用封装好的函数计算遮罩
                //water---用于判断水的深浅
                //foam---用于获得生成浮沫区域
                float waterDepthMask = ComputeEdge(i.screenPos, _CameraDepthTexture, _EdgeDistance);
                float foamDepthMask = ComputeEdge(i.screenPos, _CameraDepthTexture, foamDistance);

                //***浮沫Foam***
                //扰动图采样
                //扰动图是具有方向性的，所以需要两个维度
                //方向性也就意味着能向上下左右任意方向移动，向量取值范围为[-1,1]
                float2 distortMask = tex2D(_DistortTex, i.distortUV).xy;
                distortMask = distortMask * 2 - 1;
                distortMask *= _DistortInt;
                //噪声图采样---使用扰动图进行扰动
                float2 t = frac(_Time.x * _FoamSpeed);
                float2 noiseUV = float2(i.noiseUV + t + distortMask);
                float foamMask = tex2D(_NoiseTex, noiseUV);
                //获得浮沫遮罩
                float edgeFoamMask = smoothstep(foamDepthMask - _FoamSmooth, foamDepthMask + _FoamSmooth, foamMask);
                float smallFoamMask = smoothstep(foamMask - _FoamSmooth, foamMask + _FoamSmooth, _SmallFoamSize);
                float finalFoam = edgeFoamMask + smallFoamMask;

                //水的最终计算
                float4 waterCol = lerp(_ShallowCol, _DepthCol, waterDepthMask);
                //将浮沫融合进水
                float4 finalCol = lerp(waterCol, _FoamCol, finalFoam);

                return finalCol;
            }
            ENDCG
        }
    }
    Fallback Off
}