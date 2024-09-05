Shader "MineselfShader/Test/TwoMaterial"
{
    Properties
    {
        _NoiseTex("NoiseTexture", 2D) = "white"{}
        _Int("Intensity", Range(0, 1)) = 0.5

        _DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        _NDiffCol("NoiseDiffuseColor", COLOR) = (1,1,1,1)
        _DiffInt("DiffuseIntenisty", Range(0, 3)) = 1
        _NDiffInt("NoiseDiffuseIntensity", Range(0, 3)) = 1

        _SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        _NSpecCol("NoiseSpecularColor", COLOR) = (1,1,1,1)
        _SpecInt("SpecularIntenisty", Range(0, 3)) = 1
        _NSpecInt("SpecularIntensity", Range(0, 3)) = 1
        _Gloss("Gloss", Range(1, 100)) = 30
        _NGloss("NoiseGloss", Range(1, 100)) = 30
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
            #include "Lighting.cginc"
			
            //变量申明
            sampler2D _NoiseTex;
            float _Int;

            fixed4 _DiffCol;
            fixed4 _NDiffCol;
            float _DiffInt;
            float _NDiffInt;

            fixed4 _SpecCol;
            fixed4 _NSpecCol;
            float _SpecInt;
            float _NSpecInt;
            float _Gloss;
            float _NGloss;
                
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
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float noiseMask = tex2D(_NoiseTex, i.uv);
                noiseMask = step(_Int, noiseMask);

                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                float3 diffCol = lerp(_NDiffCol, _DiffCol, noiseMask);
                float3 diffInt = lerp(_NDiffInt, _DiffInt, noiseMask);
                float gloss = lerp(_NGloss, _Gloss, noiseMask);
                float3 specCol = lerp(_NSpecCol, _SpecCol, noiseMask);
                float3 specInt = lerp(_NSpecInt, _SpecInt, noiseMask);

                float3 ambientRGB = diffCol * unity_AmbientSky;

                float diffuse = saturate(dot(nDir, lDir));
                float3 diffuseRGB = _LightColor0 * diffCol * diffInt * diffuse;

                float specular = pow(saturate(dot(rlDir, vDir)), gloss);
                float3 specularRGB = _LightColor0 * specCol * specInt * specular;

                float3 finalRGB = ambientRGB + diffuseRGB + specularRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}