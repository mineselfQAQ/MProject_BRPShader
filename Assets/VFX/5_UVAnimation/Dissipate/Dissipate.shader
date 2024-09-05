Shader "MineselfShader/VFX/5-UVAnimation/Dissipate"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTexture", 2D) = "white"{}
        _Control("Control", Range(0, 1)) = 0
        _End("End", Float) = 0
        [Space(5)]
        _uvX("UV:X", Float) = 1
        _uvY("UV:Y", Float) = 1
        [Space(5)]
        _FresnelPow("FresnelPower", Range(0, 10)) = 3
        [Space(10)]
        [HDR]_Color("Color", COLOR) = (1,1,1,1)
        _Dist("Distance", Range(0, 10)) = 0
        _TransitionInt("TransitionIntensity", Float) = 0
        _MinMax("MinMax", vector) = (-1,1,0,0)

        
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��
            #include "..\..\..\_Common\MyLib.cginc"
			
            //��������
            sampler2D _MainTex;
            float _Control;
            float _End;
            float _uvX;
            float _uvY;
            float _FresnelPow;

            fixed4 _Color;
            float _Dist;
            float _TransitionInt;
            float2 _MinMax;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float3 normal : NORMAL;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
                float mask : TEXCOORD3;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;

                _Control = Remap(_Control, 0, 1, 0, _End);

                //��uvUnwarp���ƣ�����pos��uvPos���л�
                //������Ҫ�������������Ⱥ���ɢЧ��
                v.uv2 -= 0.5;
                v.uv2 = float2(v.uv2.x * _uvX, v.uv2.y * _uvY);
                float4 uvPos = float4(v.uv2.x, _Dist, v.uv2.y, 0);
                float t = Remap(v.vertex.y, _MinMax.x, _MinMax.y, 1, 0);//���ֻ�������Ϊ0������Ϊ1
                float mask = smoothstep(_Control, _Control - _TransitionInt, t);//��ò�ͣ�ı������
                float4 pos = lerp(v.vertex, uvPos, mask);

                o.mask = mask;

                o.pos = UnityObjectToClipPos(pos);

                o.uv = v.uv;
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                //�����������
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //�������
                float3 ambient = unity_AmbientSky;
                float diffuse = saturate(dot(lDir, nDir));
                float fresnel = pow(1 - saturate(dot(nDir, vDir)), _FresnelPow);

                //ͨ��ǰ����õ�control�����ɫ(ע����Ҫfloat3������ɫ)
                float3 mask = i.mask * _Color;

                float3 finalRGB = (ambient + diffuse) * mainTex + fresnel + mask;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}