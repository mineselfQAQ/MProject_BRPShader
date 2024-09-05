Shader "MineselfShader/VFX/11-ScreenUV/ScreenUV1"
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
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 screenUV : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //求屏幕坐标uv
                o.screenUV = o.pos.xy / o.pos.w;//透视除法
                o.screenUV.y *= _ProjectionParams.x;//辅助操作---根据情况翻转y轴
                o.screenUV = o.screenUV * 0.5 + 0.5;//[-1,1]--->[0,1]
                float aspect = _ScreenParams.y / _ScreenParams.x;//辅助操作---长宽比计算
                o.screenUV.y *= aspect;//辅助操作---应用长宽比
                o.screenUV *= _Scale;//缩放

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.screenUV);
                
                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}