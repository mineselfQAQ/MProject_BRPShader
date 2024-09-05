Shader "MineselfShader/VFX/12-Particle/CustomData"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _DissolveTex("DissolveTexture", 2D) = "white"{}
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
            sampler2D _DissolveTex; float4 _DissolveTex_ST;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 params : TEXCOORD1;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 params : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                //uv1---用于主纹理
                //params.xy提供了位移功能
                //params.z提供了缩放功能
                o.uv = (v.uv - 0.5) * v.params.z + 0.5;//需要在[-0.5,0.5]的情况下进行缩放
                o.uv = o.uv - v.params.xy;
                //uv2---用于溶解
                o.uv2 = TRANSFORM_TEX(v.uv, _DissolveTex);

                o.params = v.params;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                float dissolveMask = tex2D(_DissolveTex, i.uv2);

                float3 finalRGB = mainTex.rgb;
                float alpha = step(dissolveMask, i.params.w) * mainTex.a;//params.w提供溶解功能

                return float4(mainTex.rgb, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}