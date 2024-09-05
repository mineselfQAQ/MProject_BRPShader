Shader "MineselfShader/VFX/4-VertexAnimation/Banner"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Range(0, 2)) = 1
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
            Cull Off//需要显示旗帜的背面，需要关闭背面剔除
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex; float4 _MainTex_ST;
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


                //计算旗帜摆动
                float mask = v.uv.x;//正常的uv应该是左下(0,0)右上(1,1)，那么uv.x就是左0右1
                float t = frac(_Time.y * _Speed);
                v.vertex.x += sin((t + v.vertex.z) * UNITY_TWO_PI) * _Int * mask;//需要注意的是这里的x和z是根据物体自身坐标轴来的

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
    Fallback "Diffuse"
}