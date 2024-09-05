Shader "MineselfShader/Test/PhongShading"
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
                float3 wNormal : TEXCOORD0;
                float3 wvDir : TEXCOORD1;
                float3 wlDir : TEXCOORD2;
                float3 wrlDir : TEXCOORD3;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wvDir = WorldSpaceViewDir(v.vertex);
                o.wlDir = WorldSpaceLightDir(v.vertex);
                o.wrlDir = reflect(-o.wlDir, o.wNormal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 vDir = normalize(i.wvDir);
                float3 lDir = normalize(i.wlDir);
                float3 rlDir = normalize(i.wrlDir);

                float diffuse = saturate(dot(nDir, lDir));
                float specular = pow(saturate(dot(vDir, rlDir)), _Gloss);

                float3 finalRGB = (diffuse + specular).rrr;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}