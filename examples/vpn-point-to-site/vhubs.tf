locals {
  vhubs = {
    weu = {
      location       = "westeurope"
      address_prefix = "10.0.0.0/23"
      point_to_site_vpn = {
        vpn_server_configuration_name = "weu-p2s-vpn-config"
        gateway_name                  = "weu-p2s-gateway"
        scale_unit                    = 2

        authentication_types = ["Certificate"]

        client_root_certificates = {
          "DigiCert-Root" = {
            name             = "DigiCert-Root-CA"
            public_cert_data = <<EOF
MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
EOF
          }
        }

        client_revoked_certificates = {
          "Revoked-Cert-1" = {
            name       = "Compromised-Certificate"
            thumbprint = "1234567890ABCDEF1234567890ABCDEF12345678"
          }
        }

        radius = {
          server = [
            {
              address = "10.0.0.10"
              secret  = "radiusSecret123!"
              score   = 10
            },
            {
              address = "10.0.0.11"
              secret  = "backupRadiusSecret456!"
              score   = 5
            }
          ],
          client_root_certificate = {
            name       = "RADIUS-Client-Root"
            thumbprint = "0987654321ABCDEF0987654321ABCDEF09876543"
          },
          server_root_certificate = {
            name             = "RADIUS-Server-Root"
            public_cert_data = "MIID4jCCAsqgAwIBAgIQByXhXOLV..."
          }
        }

        vpn_client_configuration = {
          address_pool = ["172.16.0.0/24", "192.168.0.0/24"]
          dns_servers  = ["10.0.0.4", "10.0.0.5"]

          included_routes = [
            "10.0.0.0/8",
            "172.16.0.0/12",
            "192.168.0.0/16"
          ]
        }

        ipsec_policy = {
          sa_lifetime_seconds    = 28800
          sa_data_size_kilobytes = 102400000
          ipsec_encryption       = "AES256"
          ipsec_integrity        = "SHA256"
          ike_encryption         = "AES256"
          ike_integrity          = "SHA384"
          dh_group               = "DHGroup24"
          pfs_group              = "PFS24"
        }
      }
    }
  }
}
