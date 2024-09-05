Shader "MineselfShader/Test/Rampmap"
{
    Properties
    {
        _Rampmap("Rampmap", 2D) = "white"{}
        _uvY("uvY", Range(0, 1)) = 0.5
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
            sampler2D _Rampmap;
            float _uvY;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));

                float halfLambert = dot(nDir, lDir) * 0.5 + 0.5;

                float2 uv = i.uv;
                uv.x = halfLambert;
                uv.y = _uvY;

                float3 rampmap = tex2D(_Rampmap, uv);

                float3 finalRGB = rampmap;
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}