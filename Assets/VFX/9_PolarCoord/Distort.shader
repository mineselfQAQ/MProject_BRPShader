Shader "MineselfShader/VFX/9-PolarCoord/Distort_Polar"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 10)) = 1
        _Int("Intensity", Float) = 1
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
            sampler2D _MainTex; float4 _MainTex_ST;
            fixed4 _Color;
            float _Speed;
            float _Int;
            
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
                
                //进行缩放操作，由于需要在贴图中心处缩放，所以需要先进行位移才行
                v.uv -= 0.5;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv += 0.5;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //核心---转换到极坐标系进行计算
                //注意:以下操作不能在顶点着色器中进行，因为在顶点着色器中还未进行插值操作
                //如Quad只有4个顶点信息，是无法进行以下操作的
                float2 polarParms = Rect2Polar(i.uv, float2(0.5, 0.5));
                float u = polarParms.x + frac(_Time.x * _Speed) * polarParms.y * _Int;//方向
                float v = polarParms.y;//远近
                float2 polarUV = float2(u, v);

                float4 mainTex = tex2D(_MainTex, polarUV);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}