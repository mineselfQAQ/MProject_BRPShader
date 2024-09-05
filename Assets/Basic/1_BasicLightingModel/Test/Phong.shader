Shader "MineselfShader/Test/Phong"
{
    Properties
    {
        _DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        _DiffInt("DiffuseIntenisty", Range(0, 3)) = 1

        _SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        _SpecInt("SpecularIntenisty", Range(0, 3)) = 1
        _Gloss("Gloss", Range(1, 100)) = 30
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
            fixed4 _DiffCol;
            float _DiffInt;

            fixed4 _SpecCol;
            float _SpecInt;
            float _Gloss;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                float3 ambientRGB = unity_AmbientSky;

                float diffuse = saturate(dot(nDir, lDir));
                float3 diffuseRGB = _LightColor0 * _DiffCol * _DiffInt * diffuse;

                float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);
                float3 specularRGB = _LightColor0 * _SpecCol * _SpecInt * specular;

                float3 finalRGB = ambientRGB + diffuseRGB + specularRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}