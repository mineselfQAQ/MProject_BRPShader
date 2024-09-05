Shader "MineselfShader/VFX/14-Glitch/ChannelGlitch"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _OffsetParams("XY:Horizontal ZW:Vertical", vector) = (0,0,0,0)
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
            float4 _OffsetParams;
                
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
                //固定通道G，也就是说绿色通道永远是正常采样
                float4 mainTex1 = tex2D(_MainTex, i.uv);
                float G = mainTex1.g;

                //可变通道RB，它们可以进行uv的偏移使通道错位从而获得故障效果
                float4 mainTex2 = tex2D(_MainTex, float2(i.uv.x - _OffsetParams.x, i.uv.y - _OffsetParams.z));
                float R = mainTex2.r;
                float4 mainTex3 = tex2D(_MainTex, float2(i.uv.x - _OffsetParams.y, i.uv.y - _OffsetParams.w));
                float B = mainTex3.b;

                float3 finalRGB = float3(R, G, B);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}