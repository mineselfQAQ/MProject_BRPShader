Shader "MineselfShader/VFX/12-Particle/SoftParticle"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _EdgeWidth("EdgeWidth", Float) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
			
            //变量申明
            sampler2D _CameraDepthTexture;

            sampler2D _MainTex;
            float _EdgeWidth;
                
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
                o.screenPos = ComputeScreenPos(o.pos);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                //求观察空间线性深度值
                float screenZRaw = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)).r;
                float eyeZLinear = LinearEyeDepth(screenZRaw);

                //求边缘
                //其中，i.screenPos.w---指的是裁剪空间物体线性深度值
                //所以两者相减能得到边缘0，两者差越大值越大的一个遮罩
                float edgeMask = saturate((eyeZLinear - i.screenPos.w) / _EdgeWidth);
                
                float3 finalRGB = mainTex.rgb;
                float alpha = mainTex.a * edgeMask;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}