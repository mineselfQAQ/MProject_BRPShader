Shader "MineselfShader/Test/ClipMode_Test2"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout" 
            "IgnoreProjector"="True"
        }
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
            sampler2D _MainTex;
            fixed4 _Color;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                mainTex.rgb = 1 - mainTex.rgb;

                float3 finalRGB = mainTex.rgb;
                finalRGB = lerp(finalRGB, _Color, finalRGB);

                clip(mainTex.a - 0.5);
                clip(mainTex.r - 0.5);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}