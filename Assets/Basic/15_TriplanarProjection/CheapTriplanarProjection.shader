Shader "MineselfShader/Basic/15-TriplanarProjection/CheapTriplanarProjection"
{
    Properties
    {
        [KeywordEnum(Normal, Pro)]_Mode("Mode", Float ) = 0
        _MainTex("MainTexture", 2D) = "white"{}
        [PowerSilder(3.0)]_Tilling("Tilling", Range(0.1, 10)) = 1
        _Sharpness("Sharpness", Range(1, 128)) = 32
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
            #pragma shader_feature _MODE_NORMAL _MODE_PRO
			
            //变量申明
            sampler2D _MainTex;
            float _Tilling;
            float _Sharpness;
                
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

                o.wPos = mul(unity_ObjectToWorld,v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);

                //计算遮罩---用于纠正背面的左右颠倒
                #if _MODE_PRO
                    float3 mask = sign(nDir) * float3(1, 1, -1);
                    float2 maskX = float2(mask.x, 1);
                    float2 maskY = float2(mask.y, 1);
                    float2 maskZ = float2(mask.z, 1);
                #endif

                //锐化边缘
                nDir = pow(abs(nDir), _Sharpness);
                nDir /= dot(nDir, float3(1, 1, 1));
                //再次加强锐化
                nDir = round(nDir);

                //计算用于采样的uv---每个轴向使用一个平面进行采样
                #if _MODE_NORMAL
                    float2 uv = lerp(i.wPos.xz, i.wPos.zy, nDir.x);
                    uv = lerp(uv, i.wPos.xy, nDir.z);
                #else
                    float2 uv = lerp(i.wPos.xz * maskY, i.wPos.zy * maskX, nDir.x);
                    uv = lerp(uv, i.wPos.xy * maskZ, nDir.z);
                #endif

                float3 mainTex = tex2D(_MainTex, uv * _Tilling);

                return float4(mainTex, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}