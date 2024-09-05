#ifndef MYLIB
#define MYLIB

//��ӳ��
float Remap(float x, float inMin, float inMax, float outMin, float outMax)
{
    return (outMax - outMin) / (inMax - inMin) * (x - inMin) + outMin;
}
//�����---ȡֵ��Χ[0,1]
//��һ������Ϊ����ά�ȣ��ڶ�������Ϊ���ά�ȣ���Hash13()---����1D�����3D
float3 Hash23(float2 uv)
{
	float3 x = float3(uv.xyx);
	x = dot(x, float3(127.1, 311.7, 74.7));
	float3 y = float3(uv.yxx);
	y = dot(y, float3(269.5, 183.3, 246.1));
	float3 z = float3(uv.xyy);
	z = dot(z, float3(113.5, 271.9, 124.6));

	float3 ret = frac(sin(float3(x.x, y.x, z.x)) * 43758.5453123);

	return ret;
}



//RGB��HSVɫ�ʿռ�Ļ���ת������
float3 RGB2HSV(float3 c)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = lerp(float4(c.bg, K.wz),
					float4(c.gb, K.xy),
					step(c.b, c.g));
    float4 q = lerp(float4(p.xyw, c.r),
					float4(c.r, p.yzx),
					step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
				  d / (q.x + e),
				  q.x);
}
float3 HSV2RGB(float3 c)
{
    float3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6.0) -3.0) - 1.0,
					   0.0, 1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);//Cubic smoothing
    return c.z * lerp(float3(1,1,1), rgb, c.y);
}
float3 HSV2RYB(float3 c)
{
	//�Ƚ�RGBӳ��ΪRYB
	float hue = fmod(c.x * 6, 6);
    if(hue >= 0 && hue <= 2)
        hue = 0.5 * hue;
    else if(hue > 2 && hue <= 3)
        hue = hue - 1;
    else if(hue > 3 && hue <= 4)
        hue = 1.5 * hue - 2.5;
    else if(hue > 4 && hue <= 5)
        hue = hue - 0.5;
    else if(hue > 5 && hue <= 6)
        hue = 1.5 * hue - 3;
    hue = hue * (1.0 / 6.0);
	//��ת��
    float3 rgb = clamp(abs(fmod(hue * 6.0 + float3(0.0, 4.0, 2.0), 6.0) -3.0) - 1.0,
					   0.0,
					   1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);//Cubic smoothing
    return c.z * lerp(float3(1,1,1), rgb, c.y);
}
//�Ƕ�Degree�뻡��Radian�Ļ���ת������
float Deg2Rad(float angle)
{
	return angle * UNITY_PI / 180.0f;
}
float Rad2Deg(float rad)
{
	return rad * (180.0f / UNITY_PI);
}



//������ת����
float2x2 RotationMat(float rad)
{
	float2x2 rM = float2x2(cos(rad), -sin(rad),
						   sin(rad), cos(rad));
	return rM;
}
//UV�任---Ҫע��:�����ƽ�ƻ������ת��ķ����ƶ�
float2 UVTransform(float2 uv, float2 scale, float rotation, float2 offset, float2 pivot)
{
	//���ĵ�
	uv -= pivot;
	//������
	uv *= scale;
	//����ת
	float2x2 rM = RotationMat(rotation);
	uv = mul(rM, uv);
	//���ƽ��
	uv -= offset;
	//�ƻ�ԭ��
	uv += pivot;

	return uv;
}
float2 UVTransform(float2 uv, float2 scale, float rotation, float2 offset)
{
	//Ĭ�������ѡ��(0.5,0.5)����Ϊ��ת���Ľ�����ת

	uv -= float2(0.5, 0.5);//������ת
	//������
	uv *= scale;
	//����ת
	float2x2 rM = RotationMat(rotation);
	uv = mul(rM, uv);
	//���ƽ��
	uv -= offset;
	uv += float2(0.5, 0.5);//������ת

	return uv;
}
float2 RandomUVTransform(float2 uv, float2 scaleMinMax, float2 rotationMinMax, float2 randomSeed)
{
	//��3�����ֵ�����ֵ��Χ[0,1]
	float3 random = Hash23(randomSeed);

	//���ƽ��ֵ
	float2 offset = random.xy;
	//�����תֵ
	//ʹ����*16��frac()�ķ����õ�����һ�����ֵ
	//ԭ��ֵ��ȡֵ��ΧΪ[0,1]��*16��Ϊ[0,16]������frac()�������ܵõ�һ����ǰ�治ͬ�����ֵ
	float rotation = lerp(rotationMinMax.x, rotationMinMax.y, frac(random.z * 16));
	rotation = Deg2Rad(rotation);
	//�������ֵ
	float2 scale = lerp(scaleMinMax.x, scaleMinMax.y, random.z);

	return UVTransform(uv, scale, rotation, offset, float2(0.5, 0.5));
}

//ֱ������ϵת������ϵ
//����---(uv��ԭ��)    ���---(�Ƕȣ��뾶)
//��������������uv������������ǣ�
//theta---��x��������Ϊ��ʼ��ʱ����ת����Χ[0,1]
//r---���Բ�뾶1
float2 Rect2Polar(float2 uv, float2 pivot) 
{
    uv = uv - pivot;//uvĬ��ȡֵ��Χ[0,1]��������˵������Ҫ����[-0.5,0.5]������pivot������˵��ȡ(0.5,0.5)
    float theta = atan2(uv.y, uv.x);// atan()ֵ��[-��/2, ��/2]һ�㲻�ã�atan2()ֵ��[-��, ��]
	theta = frac(theta / UNITY_TWO_PI);//ӳ�����x��������Ϊ��ʼ��ʱ����ת����Χ[0,1]
    float r = length(uv);
	r *= 2;//��������Բ�뾶Ϊ0.5ӳ����1

    return float2(theta, r);
}

//BillboardЧ��
//ʹ�÷���---ֱ�Ӵ���v.vertex������õĽ������UnityObjectToClipPos()��
float3 Billboard(float4 v)
{
	//����ǰ����
	float3 forwardDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
	forwardDir = normalize(forwardDir);

	//������ʱ������--->������--->������
	float3 upDir = abs(forwardDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
	float3 rightDir = normalize(cross(forwardDir, upDir));
	upDir = normalize(cross(rightDir, forwardDir));

	//����ռ��Billboard�ĺ���---�任����λ��ʹ������ӽ�
	float3x3 rotationMat = float3x3(rightDir, upDir, -forwardDir);
	float3 vertex = mul(transpose(rotationMat), v.xyz);

	return vertex;
}
float3 Billboard_cylindrical(float4 v)//�������---���������򲻶���ֻ�����������
{
	//����ǰ����
	float3 forwardDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1)).xyz;
	forwardDir.y = 0;
	forwardDir = normalize(forwardDir);

	//������ʱ������--->������--->������
	float3 upDir = abs(forwardDir.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
	float3 rightDir = normalize(cross(forwardDir, upDir));
	upDir = normalize(cross(rightDir, forwardDir));

	//����ռ��Billboard�ĺ���---�任����λ��ʹ������ӽ�
	float3x3 rotationMat = float3x3(rightDir, upDir, -forwardDir);
	float3 vertex = mul(transpose(rotationMat), v.xyz);

	return vertex;
}

//ͼ�λ���
//3.Բ		��Ҫ������[0,1]uv		ע�⣺�������Ѿ������ĵ��Ѿ��Ƶ�(0.5,0.5)
float DrawCircle(float2 uv, float r, float blur)
{
	//���ｫ��Ĭ��ӳ�䵽[-0.5,0.5]��Ҳ����ԭ������Ϊ(0.5,0.5)
	float2 dist = uv - float2(0.5, 0.5);

	//ע�⣺����dot()Ҫ��4����Ϊdot()�Ľ��ȡֵ��ΧΪ[0,0.25]����Ҫӳ��Ϊ[0,1]
	//��Ϊǰ���dist���е���λ�Ʋ�������������ı����ǲ�����Ӱ���
	float finalMask = 1 - smoothstep(r - (r * blur),
									 r + (r * blur),
									 dot(dist, dist) * 4);
	return finalMask;
}
float DrawCircle(float2 uv, float r, float2 center, float blur)
{
    //uv��Ҫλ�ƣ�����˵��uv��[0,1]ӳ�䵽[-center,1-center]
	//���ｫ��Ĭ��ӳ�䵽[-0.5,0.5]��Ҳ����ԭ������Ϊ(0.5,0.5)
	float2 dist = uv - center;

	//ע�⣺����dot()Ҫ��4����Ϊdot()�Ľ��ȡֵ��ΧΪ[0,0.25]����Ҫӳ��Ϊ[0,1]
	//��Ϊǰ���dist���е���λ�Ʋ�������������ı����ǲ�����Ӱ���
	float finalMask = 1 - smoothstep(r - (r * blur),
									 r + (r * blur),
									 dot(dist, dist) * 4);
	return finalMask;
}

//***
//�����Ե---ʹ�����ͼ
//ע�⣺���紦Ϊ0��ԽԶֵԽ��
//***
float ComputeEdge(float4 screenPos, sampler2D cameraDepthTexture, float edgeWidth)
{
	//��۲�ռ��������ֵ
    float screenZRaw = SAMPLE_DEPTH_TEXTURE_PROJ(cameraDepthTexture, UNITY_PROJ_COORD(screenPos)).r;
    float eyeZLinear = LinearEyeDepth(screenZRaw);

    //���Ե
    //���У�i.screenPos.w---ָ���ǲü��ռ������������ֵ
    //������������ܵõ���Ե0�����߲�Խ��ֵԽ���һ������
    float edgeMask = saturate((eyeZLinear - screenPos.w) / edgeWidth);

	return edgeMask;
}

//***
//���߻��
//***
//Linear
float3 normalBlend_linear(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = n1 + n2;
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//Common
float3 normalBlend_common(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy + n2.xy, 1);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//PD
float3 normalBlend_pd(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy * n2.z + n2.xy * n1.z, n1.z * n2.z);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//UDN
float3 normalBlend_udn(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy + n2.xy, n1.z);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//Whiteout
float3 normalBlend_whiteout(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    float3 blendNormal = float3(n1.xy + n2.xy , n1.z * n2.z);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//RNM
float3 normalBlend_rnm(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float3 n1 = UnpackNormal(tex2D(t1, uv * s1));
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    n1.z += 1;
    n2.xy *= -1;
    float3 blendNormal = dot(n1, n2) * n1 - n2 * n1.z;
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}
//Unity
float3 normalBlend_unity(float2 uv, float3x3 tbn, sampler2D t1, sampler2D t2, float s1, float s2)
{
	float4 n1 = float4(UnpackNormal(tex2D(t1, uv * s1)), 0);
    float3 n2 = UnpackNormal(tex2D(t2, uv * s2));
    n1.w = -n1.z;
    float3 blendNormal;
    blendNormal.x = dot(n1.zxx, n2.xyz);
    blendNormal.y = dot(n1.yzy, n2.xyz);
    blendNormal.z = dot(n1.xyw, -n2.xyz);
    float3 finalNormal = normalize(mul(blendNormal, tbn));

	return finalNormal;
}


#endif