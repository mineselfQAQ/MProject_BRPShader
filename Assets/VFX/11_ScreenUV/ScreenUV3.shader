Shader "MineselfShader/VFX/11-ScreenUV/ScreenUV3"
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
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                o.screenPos = ComputeScreenPos(o.pos);//关键---计算屏幕空间坐标

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 screenPos = i.screenPos;
                float aspect = _ScreenParams.y / _ScreenParams.x;//计算长宽比
                screenPos.y *= aspect;//应用长宽比
                screenPos.xy *= _Scale;//缩放

                //SAMPLE_DEPTH_TEXTURE_PROJ---大部分情况下就是tex2Dproj()
                //UNITY_PROJ_COORD---大部分情况下直接返回
                float4 mainTex = SAMPLE_DEPTH_TEXTURE_PROJ(_MainTex, UNITY_PROJ_COORD(screenPos));//进行透视除法操作并采样
                
                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}