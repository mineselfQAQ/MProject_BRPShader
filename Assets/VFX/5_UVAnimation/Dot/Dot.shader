Shader "MineselfShader/VFX/5-UVAnimation/Dot"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 0
        _SizeParams("DotNums", vector) = (16, 9, 0, 0)
        _Int("Intensity", Range(0, 1)) = 0
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
            float _TimeSwitch;
            float2 _SizeParams;
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

                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //计算时间
                float t = lerp(_Int, frac(_Time.y * _Int), _TimeSwitch);

                //计算遮罩
                float dotMask = distance(frac(i.uv * _SizeParams.xy), float2(0.5, 0.5));//小圆点遮罩
                float lineMask = i.uv.x;//左0右1遮罩
                float finalMask = step(t * 2, dotMask + lineMask);//由于两者相加后取值范围[0,2]，所以对于[0,1]的t需要乘2

                float4 mainTex = tex2D(_MainTex, i.uv);

                float3 finalRGB = mainTex.rgb;
                float alpha = 1 - finalMask;//想要_Int从0到1为从无到有，所以需要使用一减

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}