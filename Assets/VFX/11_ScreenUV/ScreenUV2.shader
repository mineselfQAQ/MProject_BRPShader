Shader "MineselfShader/VFX/11-ScreenUV/ScreenUV2"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Scale("Scale", vector) = (1,1,0,0)
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
            sampler2D _MainTex;
            float2 _Scale;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //顶点输出
            struct v2f {};//必须的pos放在了顶点着色器输入中---因为需要使用out所以不能写在顶点输出

            //顶点着色器
            v2f vert (appdata v, out float4 pos : SV_POSITION)
            {
                v2f o;

                pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i, UNITY_VPOS_TYPE screenPos : VPOS) : SV_Target
            {
                //直接获取屏幕空间UV
                float2 screenUV = screenPos.xy;
                screenUV = screenUV * 0.01 * _Scale;//由于起始状态贴图太小了，所以需要乘以0.01使其变大

                float4 mainTex = tex2D(_MainTex, screenUV);
                
                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}