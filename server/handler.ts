import { S3, Lambda, Athena } from 'aws-sdk';
import { APIGatewayProxyHandler, APIGatewayEvent, Callback, Context, Handler } from 'aws-lambda';
import 'source-map-support/register';

const s3 = new S3({ apiVersion: '2006-03-01' });
// const athena = new Athena({
//   apiVersion: '2017-05-18',
//   region: 'ap-northeast-1'
// });

interface BeaconRequest {
  username: string,
  hostname: string,
  created_at: string,
  machine_type: 'mac' | 'win',
  unixTime?: number;
}
export const beacon: APIGatewayProxyHandler = async (event: APIGatewayEvent, _contex: Context, callback: Callback) => {

  const now = new Date();
  try {

    if (now.getTimezoneOffset() !== -540) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Invalid Request', input: event }, null, 2)
      }
    }
    const yyyy = now.getFullYear();
    const MM = new Date().getMonth();
    const dd = new Date().getDate();

    const body = parser<BeaconRequest>(event.body);
    if (!body) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Invalid Request', input: event }, null, 2)
      }
    }
    body.unixTime = new Date(body.created_at).valueOf();

    const params = {
      Bucket: `beacon`,
      Key: `${yyyy}/${MM}/${dd}/${body.username}.json`,
    };

    const res = await s3.getObject(params).promise();
    const bodyStr = res.Body.toString();

    const results = await s3.putObject({
      ...params,
      Body: `${bodyStr}\n${JSON.stringify(body)}`
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Success',
        input: event,
      }, null, 2),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Server error',
        input: event,
        error: error
      }, null, 2),
    };
  }
}

function parser<T>(str: string): T | false {
  try {
    return JSON.parse(str);
  } catch (error) {
    return false
  }
}