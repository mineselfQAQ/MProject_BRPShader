Shader "MineselfShader/Template/BasicTemplate"
{
    Properties
    {
        _Cubemap("Cubemap", CUBE) = ""{}
        _Mipmap("Mipmap", Range(0, 8)) = 0
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
            samplerCUBE _Cubemap;
            float _Mipmap;
                
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

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                float3 rvDir = normalize(reflect(-vDir, nDir));

                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _Mipmap));

                return float4(cubemap, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}