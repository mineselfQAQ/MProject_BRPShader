Shader "MineselfShader/VFX/4-VertexAnimation/Bounce"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 2)) = 1
        _Dist("Distance", Float) = 1
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
            sampler2D _MainTex; float4 _MainTex_ST;
            float _Speed;
            float _Dist;
                
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

                //计算顶点位移---得到弹跳效果
                float t = frac(_Time.y * _Speed);
                v.vertex.z += abs(sin(t * UNITY_TWO_PI)) * _Dist;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}