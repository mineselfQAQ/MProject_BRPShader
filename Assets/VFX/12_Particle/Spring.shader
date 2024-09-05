Shader "MineselfShader/VFX/12-Particle/Spring"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [HDR]_EndColor("EndColor", COLOR) = (1,0,0,1)
        _Frequency("Frequency", Float) = 5
        _Amplitude("Amplitude", Float) = 4
        _TimeOffset("TimeOffset", Float) = 0
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
            sampler2D _MainTex;
            fixed4 _EndColor;
            float _Frequency;
            float _Amplitude;
            float _TimeOffset;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float age : TEXCOORD1;
                float4 color : COLOR;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float age : TEXCOORD1;
                float4 color : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;

                //获取流动时间---_TimeOffset获得材质与材质之间的偏移(可以使起伏时间不同)
                float t = _Time.y + _TimeOffset;
                float offset = sin(t * _Frequency) * _Amplitude;//y轴偏移
                v.vertex.y += offset * v.age;//应用偏移，age---下侧不动上侧动

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;
                o.age = v.age;
                o.color = v.color;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                mainTex.rgb *= i.color;

                float3 finalRGB = lerp(mainTex.rgb, _EndColor, i.age);//age---下侧原色，上侧_EndColor
                float alpha = mainTex.a;

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}