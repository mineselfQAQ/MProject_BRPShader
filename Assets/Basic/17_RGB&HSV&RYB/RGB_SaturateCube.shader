Shader "MineselfShader/Basic/17-RGB&HSV&RYB/RGB_SaturateCube"
{
    Properties
    {
        _Saturate("Saturate", Range(0, 1)) = 1
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
            #include "..\..\_Common\MyLib.cginc"
			
            //变量申明
            float _Saturate;
                
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
                //核心，也是唯一的一句
                //给定HSV，转为RGB并显示出来
                //其中uv可以提供两个维度，还有一个维度需要使用一个滑条控制
                return float4(HSV2RGB(float3(i.uv.x, _Saturate, i.uv.y)), 1);
            }
            ENDCG
        }
    }
    Fallback Off
}