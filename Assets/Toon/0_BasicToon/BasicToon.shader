Shader "MineselfShader/Toon/0-BasicToon/BasicToon"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Col("Color", COLOR) = (1,1,1,1)

        [Header(Ambient)][Space(5)]
        [HDR]_AmbiCol("AmbientColor", COLOR) = (0,0,0,0)

        [Header(Diffuse)][Space(5)]
        [HDR]_DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        _EdgeSmooth("EdgeSmooth", Range(0, 0.1)) = 0.01
        
        [Header(Specular)][Space(5)]
        [HDR]_SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        _Gloss("Gloss", Range(1, 100)) = 30
        _SpecEdgeSmooth("SpecularEdgeSmooth", Range(0, 0.1)) = 0.01
        
        [Header(Fresnel)][Space(5)]
        [HDR]_FresnelCol("FresnelColor", COLOR) = (1,1,1,1)
        _FresnelEdge("FresnelEdge", Range(0, 1)) = 0.7
        _FresnelThreshold("FresnelThreshold", Float) = 0.1
        _FresnelSmooth("FresnelSmooth", Range(0, 0.1)) = 0.01
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags
            {
	            "LightMode" = "ForwardBase"
	            "PassFlags" = "OnlyDirectional"
            }
            //渲染状态
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
            #include "Lighting.cginc"
			#include "AutoLight.cginc"
            #pragma multi_compile_fwdbase

            //变量申明
            sampler2D _MainTex;
            fixed4 _Col;

            fixed4 _AmbiCol;

            fixed4 _DiffCol;
            float _EdgeSmooth;

            float _SpecEdgeSmooth;
            fixed4 _SpecCol;
            float _Gloss;

            fixed4 _FresnelCol;
            float _FresnelEdge;
            float _FresnelThreshold;
            float _FresnelSmooth;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float2 uv : TEXCOORD2;
                SHADOW_COORDS(3)
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                TRANSFER_SHADOW(o)

                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                //向量处理
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                float3 hDir = normalize(lDir + vDir);

                //环境光
                float3 ambiRGB = _AmbiCol;
                
                //阴影值
                float shadow = SHADOW_ATTENUATION(i);
                //漫反射
                float diffuse = dot(lDir, nDir);
                float diffMask = diffuse;//用于边缘光
                diffuse = smoothstep(-_EdgeSmooth, _EdgeSmooth, diffuse);
                float3 diffRGB = diffuse * _DiffCol * _LightColor0 * shadow;

                //高光反射
                float specular = pow(dot(hDir, nDir) * diffuse, _Gloss * _Gloss);
                specular = smoothstep(0.005, 0.005 + _SpecEdgeSmooth, specular);
                float3 specularRGB = specular * _SpecCol * _LightColor0 * shadow;

                //边缘光
                float fresnel = 1 - dot(vDir, nDir);
                fresnel *= pow(diffMask, _FresnelThreshold);
                fresnel = smoothstep(_FresnelEdge - _FresnelSmooth, _FresnelEdge + _FresnelSmooth, fresnel);
                float3 fresnelRGB = fresnel * _FresnelCol;

                //合成---光照部分：环境光+漫反射+高光反射+边缘光
                float3 lightRGB = ambiRGB + diffRGB + specularRGB + fresnelRGB;
                //合成---自身颜色属性：颜色值*贴图
                float3 albedo = _Col * mainTex;

                float3 finalRGB = albedo * lightRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}