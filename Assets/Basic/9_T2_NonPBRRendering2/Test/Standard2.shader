Shader "MineselfShader/Test/Standard2"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [Normal]_NormalMap("NormalMap", 2D) = "bump"{}
        [NoScaleOffset]_Cubemap("Cubemap", CUBE) = ""{}
        _CubemapMipmap("CubemapMipmap", Range(0, 8)) = 2
        [NoScaleOffset]_AO("AO", 2D) = "white"{}
        [NoScaleOffset]_RoughnessTex("Roughness", 2D) = "white"{}

        [PowerSlider(3.0)]_Gloss("Gloss", Range(1, 100)) = 30

        _R0("R0", vector) = (0.04, 0.04, 0.04, 0)
        _FresnelPow("FresnelPower", Range(0.1, 10)) = 5
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        //Pass1-ForwardBase
        Pass
        {
            //Pass Tags
            Tags
            {
                "LightMode"="ForwardBase"
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
            sampler2D _NormalMap;
            samplerCUBE _Cubemap;
            float _CubemapMipmap;
            sampler2D _AO;
            sampler2D _RoughnessTex;

            float _Gloss;

            float3 _R0;
            float _FresnelPow;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 tangent : TANGENT;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
                SHADOW_COORDS(3)
                float3x3 tbn : TEXCOORD4;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                float3 nDir = UnityObjectToWorldNormal(v.normal);
                float3 tDir = UnityObjectToWorldDir(v.tangent);
                float3 bDir = cross(nDir, tDir) * v.tangent.w * unity_WorldTransformParams.w;
                o.tbn = float3x3(tDir, bDir, nDir);

                TRANSFER_SHADOW(o);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 localNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                float3 nDir = normalize(mul(localNormal, i.tbn));
                //float3 nDir = normalize(i.wNormal);

                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                float3 rvDir = normalize(reflect(-vDir, nDir));

                float upMask = saturate(nDir.y);
                float bottomMask = saturate(-nDir.y);
                float sideMask = 1 - upMask - bottomMask;
                float3 finalMask = upMask * unity_AmbientSky + sideMask * unity_AmbientEquator + bottomMask * unity_AmbientGround;

                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(rvDir, lDir)), _Gloss);
                float3 fresnel = _R0 + (1 - _R0) * pow(1 - saturate(dot(nDir, vDir)), _FresnelPow);

                float3 mainTex = tex2D(_MainTex, i.uv);
                float ao = tex2D(_AO, i.uv);
                float roughness = tex2D(_RoughnessTex, i.uv);
                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMipmap));

                UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

                float3 dirDiff = diffuse * mainTex * _LightColor0 * atten;
                float3 indirDiff = finalMask * ao * mainTex;
                float3 dirSpec = specular * roughness * _LightColor0 * atten;
                float3 indirSpec = cubemap * ao * roughness;

                float3 finalRGB = indirDiff + dirSpec + lerp(dirDiff, indirSpec, fresnel);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
        //Pass2-ForwardAdd
        Pass
        {
            //Pass Tags
            Tags
            {
                "LightMode"="ForwardAdd"
            }
            //渲染状态
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
			#pragma multi_compile_fwdadd_fullshadows
			
            //变量申明
            sampler2D _MainTex;
            sampler2D _NormalMap;
            samplerCUBE _Cubemap;
            float _CubemapMipmap;
            sampler2D _AO;
            sampler2D _RoughnessTex;

            float _Gloss;

            float3 _R0;
            float _FresnelPow;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 tangent : TANGENT;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
                SHADOW_COORDS(3)
                float3x3 tbn : TEXCOORD4;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                float3 nDir = UnityObjectToWorldNormal(v.normal);
                float3 tDir = UnityObjectToWorldDir(v.tangent.xyz);
                float3 bDir = cross(nDir, tDir) * v.tangent.w * unity_WorldTransformParams.w;
                o.tbn = float3x3(tDir, bDir, nDir);

                TRANSFER_SHADOW(o);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 localNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                float3 nDir = normalize(mul(localNormal, i.tbn));
                //float3 nDir = normalize(i.wNormal);

                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                float3 rvDir = normalize(reflect(-vDir, nDir));

                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(rvDir, lDir)), _Gloss);
                float3 fresnel = _R0 + (1 - _R0) * pow(1 - saturate(dot(nDir, vDir)), _FresnelPow);

                float3 mainTex = tex2D(_MainTex, i.uv);
                float ao = tex2D(_AO, i.uv);
                float roughness = tex2D(_RoughnessTex, i.uv);
                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMipmap));

                UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

                float3 dirDiff = diffuse * mainTex * _LightColor0 * atten;
                float3 dirSpec = specular * roughness * _LightColor0 * atten;

                float3 finalRGB = dirDiff + dirSpec;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}