Shader "MineselfShader/Basic/15-TriplanarProjection/DirectionMask"
{
    Properties
    {
        _Sharpness("Sharpness", Range(1, 128)) = 32
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
            float _Sharpness;
                
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
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                //锐化边缘
                nDir = pow(abs(nDir), _Sharpness);
                nDir /= dot(nDir, float3(1,1,1));
                //再次加强锐化
                nDir = round(nDir);

                return float4(nDir, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}