package awsutil

import (
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gravitational/trace"
)

// ConvertS3Error wraps S3 error
func ConvertS3Error(err error) error {
	if err == nil {
		return nil
	}
	if aerr, ok := err.(awserr.Error); ok {
		switch aerr.Code() {
		case s3.ErrCodeNoSuchKey, s3.ErrCodeNoSuchBucket, s3.ErrCodeNoSuchUpload:
			return trace.NotFound(aerr.Error())
		case s3.ErrCodeBucketAlreadyExists, s3.ErrCodeBucketAlreadyOwnedByYou:
			return trace.AlreadyExists(aerr.Error())
		default:
			return trace.BadParameter(aerr.Error())
		}
	}
	return err
}
