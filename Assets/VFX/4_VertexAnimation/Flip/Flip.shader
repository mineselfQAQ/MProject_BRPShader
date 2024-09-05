Shader "MineselfShader/VFX/4-VertexAnimation/Flip"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Speed("Speed", Float) = 1
        _Int("Intensity", Float) = 1

        [HideInInspector]_Cutoff("Cutoff", Range(0, 1)) = 0.5
        [HideInInspector]_Color("Color", Color) = (1,1,1,1)
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
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex;
            float _Speed;
            float _Int;
            //以下两个属性用于Fallback---生成a通道并剔除已经被裁剪区域
            float _Cutoff;
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

                //顶点动画操作
                float mask = distance(v.vertex.y, -0.5);//遮罩，上下向遮罩，下为0，上为1
                float t = frac(_Time.y * _Speed);
                v.vertex.x += sin(t * UNITY_TWO_PI) * _Int * mask;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                
                clip(mainTex.a - _Cutoff);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback "Transparent/Cutout/VertexLit"
}