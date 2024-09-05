Shader "MineselfShader/Instance/Crystal"
{
    Properties
    {
        [Header(Diffuse)][Space(5)]
        [HDR]_DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        
        [Header(Specular)][Space(5)]
        [HDR]_SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        _Gloss("Gloss", Range(0, 100)) = 30

        [Header(Fresnel)][Space(5)]
        _FresnelPow("FresnelPower", Range(0, 10)) = 3
        [HDR]_BottomFresCol("BottomFresnelColor", COLOR) = (1,1,1,1)
        [HDR]_TopFresCol("TopFresnelColor", COLOR) = (1,1,1,1)
        _BottomRange("BottomRange", Range(0, 1)) = 0
        _TopRange("TopRange", Range(0, 1)) = 0
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

			
            //变量申明
            fixed4 _DiffCol;

            fixed4 _SpecCol;
            float _Gloss;

            float _FresnelPow;
            fixed4 _BottomFresCol;
            fixed4 _TopFresCol;
            float _BottomRange;
            float _TopRange;
            
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
                float3 wNormal : TEXCOORD0;
                float4 wPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //计算光照向量
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //计算光照---HalfLambert|Phong高光
                float3 diffuse = _DiffCol * (dot(lDir, nDir) * 0.5 + 0.6);
                float3 specular = _SpecCol * pow(saturate(dot(rlDir, vDir)), _Gloss);
                
                //计算Fresnel---上侧|下侧
                //注意：一定需要更改uv才能使用该方法获得遮罩
                float bottomMask = smoothstep(i.uv.y, 1, _BottomRange);
                float topMask = smoothstep(1 - i.uv.y, 1, _TopRange);
                float fresnel = pow(1 - saturate(dot(nDir, vDir)), _FresnelPow);
                float3 bottomFresnel = bottomMask * fresnel * _BottomFresCol;
                float3 topFresnel = topMask * fresnel * _TopFresCol;
                float3 finalFresnel = topFresnel + bottomFresnel;

                float3 finalRGB = diffuse + specular + finalFresnel;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}