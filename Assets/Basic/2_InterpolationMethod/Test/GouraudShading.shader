Shader "MineselfShader/Test/GouraudShading"
{
    Properties
    {
        _Gloss("Gloss", Range(1, 100)) = 30
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
            float _Gloss;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 wNormal = normalize(UnityObjectToWorldNormal(v.normal));
                float3 wvDir = normalize(WorldSpaceViewDir(v.vertex));
                float3 wlDir = normalize(WorldSpaceLightDir(v.vertex));
                float3 wrlDir = normalize(reflect(-wlDir, wNormal));

                float diffuse = saturate(dot(wNormal, wlDir));
                float specular = pow(saturate(dot(wvDir, wrlDir)), _Gloss);

                o.color = (diffuse + specular).rrrr;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = i.color;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}