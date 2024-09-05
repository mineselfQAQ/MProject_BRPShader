Shader "MineselfShader/Basic/3-Texture/ThreeColorWithAO"
{
    Properties
    {
        _AO("AO", 2D) = "white"{}
        _TopCol("TopColor", COLOR) = (1,1,1,1)
        _SideCol("SideColor", COLOR) = (0.9,0.9,0.9,1)
        _BottomCol("BottomColor", COLOR) = (0.8,0.8,0.8,1)
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
            sampler2D _AO; float4 _AO_ST;
            fixed4 _TopCol;
            fixed4 _SideCol;
            fixed4 _BottomCol;

			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wNormal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _AO);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //遮罩的核心:世界空间法线
                float3 nDir = normalize(i.wNormal);

                //计算上中下遮罩
                //其中上遮罩和下遮罩很好计算，只需通过世界空间法线即可知道其对应的部分
                //中遮罩其实就是除了上/下遮罩的剩余部分，只需使用一减计算即可
                float topMask = saturate(nDir.y);
                float bottomMask = saturate(-nDir.y);
                float sideMask = 1 - topMask - bottomMask;

                float3 finalRGB = _TopCol * topMask +
                                  _SideCol * sideMask +
                                  _BottomCol * bottomMask;
                
                //采样AO贴图
                float4 ao = tex2D(_AO, i.uv);
                finalRGB *= ao;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}