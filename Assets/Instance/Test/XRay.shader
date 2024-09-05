Shader "MineselfShader/Test/XRay"
{
    Properties
    {
        [HDR]_FresnelColor("FresnelColor", COLOR) = (1,1,1,1)
        _FresnelPow("FresnelPower", Range(0,10)) = 3
        _Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        //SubShader Tags
		Tags{"Queue" = "Geometry+1"}
        //Pass1---Fresnel(被遮挡部分)
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            ZWrite Off
            ZTest Greater
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            fixed4 _FresnelColor;
            float _FresnelPow;
                
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
                float3 wNormal : TEXCOORD0;
                float4 wPos : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                float fresnel = pow(1 - saturate(dot(vDir, nDir)), _FresnelPow);

                float3 finalRGB = _FresnelColor;
                float alpha = fresnel;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
        //Pass2---普通(未被遮挡部分)
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
            fixed4 _Color;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
    Fallback Off
}